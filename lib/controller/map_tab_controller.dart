import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:seeya/constants/app_router.dart';
import 'package:seeya/data/repository/repositories.dart';
import 'package:seeya/utils/utils.dart';
import 'package:seeya/utils/marker_icon_cache.dart';

import '../constants/app_secret.dart';
import '../data/enum/enums.dart';
import '../data/model/models.dart';
import '../view/common/loading_overlay.dart';



class MapTabController extends GetxController with GetSingleTickerProviderStateMixin{

  final MapTabRepository mapTabRepository;

  MapTabController({required this.mapTabRepository});







  // bottom sheet
  late AnimationController _animationController;
  var sheetHeight = Rx<double?>(null);
  double minHeight = -1;
  double maxHeight = -1;


  // map
  final double? zoomLevel = 15;
  var isMapInitialized = false.obs;
  final Completer<GoogleMapController> _mapController = Completer();
  GoogleMapController? _cachedController;
  GoogleMapController? get mapController => _cachedController;

  // markers
  var markers = <Marker>{}.obs;

  // location
  var userCurrentPosition = Rx<Position?>(null);
  StreamSubscription<Position>? _positionStreamSubscription;

  // event data
  RxList<EventModel> curEventList = <EventModel>[].obs;
  List<EventModel> allEventList = [];
  var isEventListFetched = false.obs;
  RxList<EventModel> selectedClusterMarker = <EventModel>[].obs;

  // search
  var searchResult = "".obs;
  var searchSortKey = EventSortKeyEnum.popular.obs;






  @override
  void onInit() {
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));

    // Google Maps는 별도 초기화 필요 없음 (AppDelegate에서 이미 초기화됨)
    // onMapCreated에서 isMapInitialized를 true로 설정

    super.onInit();
  }


  @override
  void onClose() {
    _animationController.dispose();
    _positionStreamSubscription?.cancel();
    _positionStreamSubscription = null;
    MarkerIconCache.clearCache();
    super.onClose();
  }

  /// Called when Google Map is created
  void onMapCreated(GoogleMapController controller) {
    if (!_mapController.isCompleted) {
      _mapController.complete(controller);
      _cachedController = controller;
      isMapInitialized(true);

      Logger().d('[MapTabController] Map created');

      WidgetsBinding.instance.addPostFrameCallback((_) {
        fetchEventList(null);
      });
    }
  }




  // Get event list
  Future<void> fetchEventList(String? eventIds) async {

    try{
      LoadingOverlay.show();

      CommonResponseModel commonResponse = await mapTabRepository.fetchEventListApi(eventIds);


      if(commonResponse.successModel != null){
        List<EventModel> response = EventModel.fromJsonList(commonResponse.successModel!.content["items"]);

        if(eventIds == null){
          sortEventsByPopularity(response);
          allEventList = response;
        } else {

        }

        curEventList.value = response;

        // 이벤트 로드 완료 후 마커 업데이트 및 카메라 이동
        if(isMapInitialized.value && curEventList.isNotEmpty) {
          await updateMarker();
          await _updateCameraToPosition(
            LatLng(curEventList[0].latitude, curEventList[0].longitude),
          );
          Logger().d('[MapTabController] Markers and camera updated after fetchEventList');
        }

      } else if(commonResponse.failModel != null) {

      }

      isEventListFetched(true);

    }catch(e, stackTrace){
      Logger().e("error ::: $e");
      Logger().e("stackTrace ::: $stackTrace");
    }finally{
      LoadingOverlay.hide();
    }

  }







  Future<void> _updateCameraToPosition(LatLng latLng) async {
    try {
      final controller = await _mapController.future;

      await controller.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: latLng,
            zoom: zoomLevel ?? 15.0,
          ),
        ),
      );
    } catch (e) {
      Logger().e('[MapTabController] Error updating camera: $e');
    }
  }




  Future<bool> getCurrentLocation() async {
    bool hasNoError = false;

    // check location service
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    // check permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    // Wait for map initialization if not ready yet
    if (!isMapInitialized.value) {
      Logger().d('[MapTabController] Waiting for map initialization...');
      await Future.delayed(const Duration(milliseconds: 300));
      if (!isMapInitialized.value) {
        Logger().w('[MapTabController] Map still not initialized');
        return false;
      }
    }

    // Get current position (always fetch fresh location)
    try {
      userCurrentPosition.value = await Geolocator.getCurrentPosition();
    } catch (e) {
      Logger().e('[MapTabController] Error getting current position: $e');
      return false;
    }

    // Move camera to current position
    await _updateCameraToPosition(
        LatLng(userCurrentPosition.value!.latitude, userCurrentPosition.value!.longitude));

    // Setup location stream if not already listening
    const locationSettings = LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 5, // 위치가 5미터 이상 변경되면 업데이트
    );

    // 거리순인 경우 sort
    if (searchSortKey.value == EventSortKeyEnum.distance && userCurrentPosition.value != null) {
      sortEventsByDistance(userCurrentPosition.value!, curEventList);
    }

    _positionStreamSubscription ??= Geolocator.getPositionStream(locationSettings: locationSettings).listen(
          (Position position) {
        userCurrentPosition.value = position;

        // 거리순인 경우 sort
        if (searchSortKey.value == EventSortKeyEnum.distance) {
          sortEventsByDistance(position, curEventList);
        }
      },
    );

    hasNoError = true;
    return hasNoError;
  }






  Future<void> updateMarker() async {

    try {
      // New markers set
      Set<Marker> newMarkers = {};

      // 클러스터링 범위 (m)
      const double clusterRadius = 15.0; // meter
      List<List<EventModel>> clusters = _clusterEvents(curEventList, clusterRadius);

      Logger().d('[MapTabController] Updating ${clusters.length} markers (from ${curEventList.length} events)');

      for (int index = 0; index < clusters.length; index++) {

        final cluster = clusters[index];
        final eventInfo = cluster.first;

        // Determine marker size based on selection
        final isSelected = selectedClusterMarker.isNotEmpty && selectedClusterMarker.first.id == eventInfo.id;
        final iconSize = isSelected ? 160 : 100;

        // Load custom marker icon using MarkerIconCache
        final icon = await MarkerIconCache.getMarkerIcon(
          "${AppSecret.s3url}${eventInfo.map_pin_image_filepath}",
          width: iconSize,
          height: iconSize,
        );

        newMarkers.add(
          Marker(
            markerId: MarkerId(eventInfo.id.toString()),
            position: LatLng(eventInfo.latitude, eventInfo.longitude),
            icon: icon,
            onTap: () async {
              // Move camera to marker
              await _updateCameraToPosition(
                LatLng(eventInfo.latitude, eventInfo.longitude),
              );

              // Toggle selection
              if(selectedClusterMarker.isNotEmpty && eventInfo.id == selectedClusterMarker.first.id){
                selectedClusterMarker.value = [];
              } else {
                selectedClusterMarker.value = cluster;
              }

              // Update markers to reflect size change
              await updateMarker();
            },
          ),
        );
      }

      // Update reactive markers set
      markers.value = newMarkers;

      Logger().i('[MapTabController] Markers updated: ${newMarkers.length} total');

    } catch (e, stackTrace) {
      Logger().e('[MapTabController] updateMarker error: $e');
      Logger().e(stackTrace);
    }

  }






  List<List<EventModel>> _clusterEvents(List<EventModel> eventList, double clusterRadius) {
    List<List<EventModel>> clusters = [];

    for (final event in eventList) {
      bool addedToCluster = false;

      for (final cluster in clusters) {
        // 클러스터 내 첫 이벤트와 거리 계산
        final firstEventInCluster = cluster.first;
        final distance = CalculateUtils.calculateDistance(
          event.latitude,
          event.longitude,
          firstEventInCluster.latitude,
          firstEventInCluster.longitude,
        );

        if (distance <= clusterRadius) {
          cluster.add(event);
          addedToCluster = true;
          break;
        }
      }

      // 새로운 클러스터 생성
      if (!addedToCluster) {
        clusters.add([event]);
      }
    }

    return clusters;
  }









  void openSearch() async {
    var result = await Get.toNamed(AppRouter.search);

    String keyword = result['keyword'];
    String eventIds = result['event_ids'];

    if(eventIds.isEmpty) eventIds = "-1";

    if(result != null){
      searchResult.value = keyword;
      await fetchEventList(eventIds);
      updateMarker();
    }

  }















  // bottom sheet
  void updateHeightOnce(double constraintsMaxHeight, double minHeightPercent) {
    sheetHeight.value ??= constraintsMaxHeight * minHeightPercent;
    if(minHeight < 0) minHeight = constraintsMaxHeight * minHeightPercent;
    if(maxHeight < 0) maxHeight = constraintsMaxHeight;
  }
  void expandSheet() {
    if(maxHeight > 0){
      sheetHeight.value = maxHeight;
      _animationController.forward();
    }
  }
  void collapseSheet() {
    if(minHeight > 0){
      sheetHeight.value = minHeight;
      _animationController.reverse();
    }
  }
  void toggleSheet(){
    if(sheetHeight.value == maxHeight){
      collapseSheet();
    }else {
      expandSheet();
    }
  }






  // sort
  void sortEventsByPopularity(List<EventModel> events) {
    events.sort((a, b) => b.popularity_score.compareTo(a.popularity_score));
  }
  void sortEventsByDistance(Position userLatLong, List<EventModel> events) {
    events.sort((a, b) {
      final distanceA = GeoUtils.calculateDistance(userLatLong, a.latitude, a.longitude);
      final distanceB = GeoUtils.calculateDistance(userLatLong, b.latitude, b.longitude);
      return distanceA.compareTo(distanceB);
    });
  }

}