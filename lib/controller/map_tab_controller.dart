import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:seeya/constants/app_router.dart';
import 'package:seeya/data/repository/repositories.dart';
import 'package:seeya/utils/utils.dart';

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
  late final NaverMapController naverMapController;

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
    initNaverMap().then((value) async {
      isMapInitialized(true);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        fetchEventList(null);
      });
    },);

    super.onInit();
  }


  @override
  void onClose() {
    _animationController.dispose();
    _positionStreamSubscription?.cancel();
    _positionStreamSubscription = null;
    naverMapController.dispose();
    super.onClose();
  }




  // Map
  Future<void> initNaverMap() async{
    await NaverMapSdk.instance.initialize(
      clientId: AppSecret.naverClientID,
      onAuthFailed: (ex) {
        Logger().e("naver map init fail ::: $ex");
      },
    );
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







  void _addMyLocationMarker() {
    naverMapController.deleteOverlay(const NOverlayInfo(type: NOverlayType.marker, id: "my_location"));
    naverMapController.addOverlay(
        NMarker(
            id: "my_location",
            position: NLatLng(userCurrentPosition.value!.latitude,userCurrentPosition.value!.longitude),
            icon: const NOverlayImage.fromAssetImage("assets/image/my_location.png"),
            size: const Size(48, 48)
        )..setZIndex(1000)
    );
  }


  void _updateCameraToPosition(NLatLng nLatLng) {
    final cameraUpdate = NCameraUpdate.scrollAndZoomTo(
      target: nLatLng,
      zoom: zoomLevel,
    );

    naverMapController.updateCamera(cameraUpdate);
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


    if (isMapInitialized.value) {
      // once
      try {
        userCurrentPosition.value ??= await Geolocator.getCurrentPosition();
      } catch (e) {
        return false;
      }

      _addMyLocationMarker();
      _updateCameraToPosition(
          NLatLng(userCurrentPosition.value!.latitude, userCurrentPosition.value!.longitude));

      // add stream
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
          _addMyLocationMarker();

          // 거리순인 경우 sort
          if (searchSortKey.value == EventSortKeyEnum.distance) {
            sortEventsByDistance(position, curEventList);
          }

        },
      );

      hasNoError = true;
    }

    return hasNoError;
  }



  void setMapData(BuildContext context) async {

    if(isMapInitialized.value && curEventList.isNotEmpty){


      var markers = await updateMarker();

      final cameraUpdate = NCameraUpdate.scrollAndZoomTo(
        target: NLatLng(curEventList[0].latitude,curEventList[0].longitude),
        zoom: zoomLevel,
      );

      // naverMapController.addOverlayAll(markers);
      naverMapController.updateCamera(cameraUpdate);
    }

  }



  Future<Set<NAddableOverlay<NOverlay<void>>>> updateMarker() async {

    // add markers
    Set<NAddableOverlay> markers = {};

    // 클러스터링 범위 (m)
    const double clusterRadius = 15.0; // merter
    List<List<EventModel>> clusters = _clusterEvents(curEventList, clusterRadius);

    for (int index = 0; index < clusters.length; index++) {

      final cluster = clusters[index];
      final eventInfo = cluster.first;

      var markerFile = await DownloadUtils.loadImageFromUrl("${AppSecret.s3url}${eventInfo.map_pin_image_filepath}");

      markers.add(
          NMarker(
            id: eventInfo.id.toString(),
            position: NLatLng(eventInfo.latitude, eventInfo.longitude),
            // caption: NOverlayCaption(text: eventInfo.eventName),
            icon: NOverlayImage.fromFile(markerFile),
            size: selectedClusterMarker.isNotEmpty && selectedClusterMarker.first.id == eventInfo.id ? const Size(80, 80) : const Size(50, 50),
          )..setOnTapListener((overlay) async {

            final cameraUpdate = NCameraUpdate.scrollAndZoomTo(
              target: NLatLng(eventInfo.latitude,eventInfo.longitude),
              zoom: zoomLevel,
            );
            naverMapController.updateCamera(cameraUpdate);

            if(selectedClusterMarker.isNotEmpty && eventInfo.id == selectedClusterMarker.first.id){
              selectedClusterMarker.value = [];
            } else {
              selectedClusterMarker.value = cluster;
            }

            await updateMarker();

          },)
      );
    }

    naverMapController.clearOverlays();
    naverMapController.addOverlayAll(markers);

    return markers;

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