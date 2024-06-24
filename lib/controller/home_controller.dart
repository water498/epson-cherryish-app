import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../constants/app_secret.dart';
import '../data/model/models.dart';
import '../data/repository/repositories.dart';

class HomeController extends GetxController{

  final HomeRepository homeRepository;

  HomeController({required this.homeRepository});


  final double? zoomLevel = 15;
  var templateList = RxList<HomeTemplateModel>();
  var isMapInitialized = false.obs;
  late final NaverMapController naverMapController;
  late final PageController pageController;



  @override
  void onInit() {
    pageController = PageController(
        initialPage: 0,
        viewportFraction: 0.9
    );

    initNaverMap().then((value) {
      isMapInitialized(true);
    },);
    super.onInit();
  }

  Future<void> initNaverMap() async{
    await NaverMapSdk.instance.initialize(
      clientId: AppSecret.naverClientID,
      onAuthFailed: (ex) {
        Logger().e("naver map init fail ::: $ex");
      },
    );
  }

  void getCurrentLocation() async {

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
      Position position = await Geolocator.getCurrentPosition();

      final cameraUpdate = NCameraUpdate.scrollAndZoomTo(
        target: NLatLng(position.latitude,position.longitude),
        zoom: zoomLevel,
      );

      naverMapController.updateCamera(cameraUpdate);
    }
  }


  void fetchTemplateList() async {

    try {

      naverMapController.clearOverlays();
      templateList.value = [];

      CommonResponseModel commonResponse = await homeRepository.fetchTemplateListApi();

      if(commonResponse.successModel != null){
        List<HomeTemplateModel> response = (Item.fromJson(commonResponse.successModel!.content).items);
        templateList.value = response;

        setMapData(response);

      } else {
        Get.snackbar("⚠️", '알 수 없는 오류가 발생하였습니다', colorText: Colors.white);
      }

    } catch (e, stackTrace) {
      Get.snackbar("⚠️", '알 수 없는 오류가 발생하였습니다', colorText: Colors.white);
      Logger().d("Error: $e");
      Logger().d("stackTrace: $stackTrace");
    }

  }

  void setMapData(List<HomeTemplateModel> response){

    if(isMapInitialized.value && response.isNotEmpty){

      // add markers
      Set<NAddableOverlay> markers = {};

      response.asMap().forEach((index, template) {
        markers.add(
            NMarker(
              id: response[index].uid,
              position: NLatLng(response[index].latitude, response[index].longitude),
              caption: NOverlayCaption(text: "${response[index].title}"),

              // icon: const NOverlayImage.fromAssetImage("assets/image/map_marker.png")
            )..setOnTapListener((overlay) {
              final cameraUpdate = NCameraUpdate.scrollAndZoomTo(
                target: NLatLng(response[0].latitude,response[0].longitude),
                zoom: zoomLevel,
              );
              naverMapController.updateCamera(cameraUpdate);

              for (int index = 0; index < templateList.length; index++) {
                var element = templateList[index];
                if (overlay.info.id == element.uid) {
                  pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
                  break;
                }
              }
            },)
        );
      });


      final cameraUpdate = NCameraUpdate.scrollAndZoomTo(
        target: NLatLng(response[0].latitude,response[0].longitude),
        zoom: zoomLevel,
      );

      naverMapController.addOverlayAll(markers);
      naverMapController.updateCamera(cameraUpdate);
    }

  }


}