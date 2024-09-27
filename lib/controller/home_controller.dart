import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_naver_map/flutter_naver_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:seeya/view/common/loading_overlay.dart';

import '../constants/app_secret.dart';
import '../data/model/models.dart';
import '../data/repository/repositories.dart';

class HomeController extends GetxController{

  final HomeRepository homeRepository;

  HomeController({required this.homeRepository});




  late final PageController pageController;
  var isInitialized = false.obs;
  RxList<TempHomeBestFrame> homeList = <TempHomeBestFrame>[].obs;






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
      LoadingOverlay.show(null);

      await homeRepository.fetchTemplateListApi();
      await Future.delayed(const Duration(milliseconds: 500));
      homeList.value = TempHomeBestFrame.dummy_data.map((data) => TempHomeBestFrame.fromJson(data)).toList();
    }catch(e, stackTrace){
      Logger().e("error ::: $e");
      Logger().e("stackTrace ::: $stackTrace");
    }finally{
      LoadingOverlay.hide();
    }

  }



}