import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:seeya/core/data/model/common/common_models.dart';
import 'package:seeya/core/data/repository/common_repository.dart';
import 'package:seeya/view/common/loading_overlay.dart';

import '../core/config/app_secret.dart';
// v1 (deprecated)
// import '../data/model/models.dart';
// import '../data/repository/repositories.dart';

class HomeController extends GetxController{

  final commonRepository = CommonRepository();




  late final PageController pageController;
  var isInitialized = false.obs;
  RxList<HomeBestFrame> homeList = <HomeBestFrame>[].obs;






  @override
  void onInit() {
    pageController = PageController(
        initialPage: 0,
        viewportFraction: 0.8
    );

    super.onInit();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      isInitialized.value = true;
      fetchHomeList();
    });

  }


  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }







  Future<void> fetchHomeList() async {

    try{
      LoadingOverlay.show();

      // v2 API
      List<HomeBestFrame> frames = await commonRepository.getHomeBestFrames();
      homeList.value = frames;

    }catch(e, stackTrace){
      Logger().e("error ::: $e");
      Logger().e("stackTrace ::: $stackTrace");
    }finally{
      LoadingOverlay.hide();
    }

  }



}