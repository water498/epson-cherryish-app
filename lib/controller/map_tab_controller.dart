import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:seeya/constants/app_router.dart';
import 'package:seeya/utils/utils.dart';

import '../constants/app_secret.dart';
import '../data/enum/enums.dart';
import '../data/model/models.dart';
import '../view/common/loading_overlay.dart';



class MapTabController extends GetxController with GetSingleTickerProviderStateMixin{

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
  var currentPosition = Rx<Position?>(null);
  StreamSubscription<Position>? _positionStreamSubscription;

  // event data
  RxList<TempEvent> curEventList = <TempEvent>[].obs;
  List<TempEvent> allEventList = [];
  var isEventListFetched = false.obs;
  RxList<TempEvent> selectedClusterMarker = <TempEvent>[].obs;

  // search
  var searchResult = "".obs;
  var searchSortKey = EventSortKeyEnum.popular.obs;






  @override
  void onInit() {
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    initNaverMap().then((value) {
      isMapInitialized(true);

      WidgetsBinding.instance.addPostFrameCallback((_) {
        fetchEventList();
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
  Future<void> fetchEventList() async {

    try{
      LoadingOverlay.show(null);

      await Future.delayed(const Duration(milliseconds: 800));

      curEventList.value = TempEvent.dummy_data.map((data) => TempEvent.fromJson(data)).toList();
      allEventList = TempEvent.dummy_data.map((data) => TempEvent.fromJson(data)).toList();
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
            position: NLatLng(currentPosition.value!.latitude,currentPosition.value!.longitude),
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




  Future<void> getCurrentLocation() async {

    // check location service
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    // check permission
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('permissions are denied');
      }
    }


    if(isMapInitialized.value){

      // once
      currentPosition.value ??= await Geolocator.getCurrentPosition();

      _addMyLocationMarker();
      _updateCameraToPosition(NLatLng(currentPosition.value!.latitude,currentPosition.value!.longitude));



      // add stream
      const locationSettings = LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 5, // 위치가 10미터 이상 변경되면 업데이트
      );
      _positionStreamSubscription ??= Geolocator.getPositionStream(locationSettings: locationSettings).listen(
            (Position position) {

          currentPosition.value = position;
          _addMyLocationMarker();

        },
      );


    }


  }



  void setMapData(BuildContext context) async {

    if(isMapInitialized.value && curEventList.isNotEmpty){


      var markers = await updateMarker(context);

      final cameraUpdate = NCameraUpdate.scrollAndZoomTo(
        target: NLatLng(curEventList[0].latitude,curEventList[0].longitude),
        zoom: zoomLevel,
      );

      // naverMapController.addOverlayAll(markers);
      naverMapController.updateCamera(cameraUpdate);
    }

  }



  Future<Set<NAddableOverlay<NOverlay<void>>>> updateMarker(BuildContext context) async {

    // add markers
    Set<NAddableOverlay> markers = {};

    // 클러스터링 범위 (m)
    const double clusterRadius = 15.0; // merter
    List<List<TempEvent>> clusters = _clusterEvents(curEventList, clusterRadius);

    for (int index = 0; index < clusters.length; index++) {

      final cluster = clusters[index];
      final eventInfo = cluster.first;

      var markerFile = await DownloadUtils.loadImageFromUrl("${AppSecret.s3url}${eventInfo.mapPinImageFilepath}");

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

            await updateMarker(context);

          },)
      );
    }

    naverMapController.clearOverlays();
    naverMapController.addOverlayAll(markers);

    return markers;

  }






  List<List<TempEvent>> _clusterEvents(List<TempEvent> eventList, double clusterRadius) {
    List<List<TempEvent>> clusters = [];

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

    if(result != null){
      searchResult.value = result;
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


}