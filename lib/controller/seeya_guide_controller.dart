import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SeeyaGuideController extends GetxController{

  var showFAB = false.obs;
  late ScrollController scrollController;


  @override
  void onInit() {
    double threshold = Get.height * 0.1;
    if(threshold <= 0){
      threshold = 100.0;
    }
    scrollController = ScrollController();
    scrollController.addListener(() {
      showFAB.value = scrollController.offset > threshold;
    });
    super.onInit();
  }


  @override
  void onClose() {
    scrollController.removeListener(() { });
    scrollController.dispose();
    super.onClose();
  }

}