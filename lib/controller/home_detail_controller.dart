import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:seeya/constants/app_secret.dart';

import '../data/model/models.dart';
import '../data/repository/repositories.dart';

class HomeDetailController extends GetxController{

  final HomeDetailRepository homeDetailRepository;

  HomeDetailController({required this.homeDetailRepository});

  var selectedTemplateUid = "";
  var isMapInitialized = false.obs;
  var showFAB = false.obs;
  ScrollController scrollController = ScrollController();
  late final NaverMapController naverMapController;

  var photoTemplate = Rx<PhotoTemplate?>(null);
  var photoLayouts = RxList<PhotoLayout>();
  var photoFilters = RxList<PhotoFilter>();


  @override
  void onInit() async {
    selectedTemplateUid = Get.arguments;

    fetchTemplateList();

    initNaverMap().then((value) {
      isMapInitialized(true);
    },);

    double threshold = Get.height * 0.1;
    if(threshold <= 0){
      threshold = 100.0;
    }
    scrollController.addListener(() {
      showFAB.value = scrollController.offset > threshold;
      Logger().d("offeset ::: ${scrollController.offset}");
    });
    super.onInit();
  }


  @override
  void onClose() {
    scrollController.removeListener(() { });
    scrollController.dispose();
    super.onClose();
  }

  Future<void> initNaverMap() async{
    await NaverMapSdk.instance.initialize(
      clientId: AppSecret.naverClientID,
      onAuthFailed: (ex) {
        Logger().e("naver map init fail ::: $ex");
      },
    );
  }



  void fetchTemplateList() async {

    try {
      CommonResponseModel commonResponse = await homeDetailRepository.fetchHomeDetailApi(selectedTemplateUid);

      if(commonResponse.successModel != null){

        PhotoTemplate responseTemplate = PhotoTemplate.fromJson(commonResponse.successModel!.content);
        List<PhotoLayout> responseLayouts = PhotoLayouts.fromJson(commonResponse.successModel!.content).photoLayouts;
        List<PhotoFilter> responseFilters = PhotoFilters.fromJson(commonResponse.successModel!.content).photoFilters;
        photoTemplate.value = responseTemplate;
        photoLayouts.value = responseLayouts;
        photoFilters.value = responseFilters;

      } else {
        Get.snackbar("⚠️", '알 수 없는 오류가 발생하였습니다', colorText: Colors.white);
      }

    } catch (e, stackTrace) {
      Get.snackbar("⚠️", '알 수 없는 오류가 발생하였습니다', colorText: Colors.white);
      Logger().d("Error: $e");
      Logger().d("stackTrace: $stackTrace");
    }

  }

  void setMapSettings(){
    if(photoTemplate.value != null && photoTemplate.value?.latitude != null && photoTemplate.value?.longitude != null && isMapInitialized.value){
      // add markers
      final marker = NMarker(id: photoTemplate.value!.uid, position: NLatLng(photoTemplate.value!.latitude, photoTemplate.value!.longitude));

      final cameraUpdate = NCameraUpdate.scrollAndZoomTo(
        target: NLatLng(photoTemplate.value!.latitude, photoTemplate.value!.longitude),
        zoom: 15,
      );
      cameraUpdate.setAnimation(animation: NCameraAnimation.none);

      naverMapController.addOverlay(marker);
      naverMapController.updateCamera(cameraUpdate);
    }
  }


}