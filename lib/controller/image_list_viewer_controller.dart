import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../data/model/models.dart';

class ImageListViewerController extends GetxController{

  late List<PhotoLayout> photoLayouts;
  var currentIndex = 0.obs;
  late PageController pageController;

  @override
  void onInit() {
    photoLayouts = Get.arguments['photo_layouts'];
    currentIndex.value = Get.arguments['index'];

    pageController = PageController(
      initialPage: currentIndex.value,
      viewportFraction: 0.85,
    );
    pageController.addListener(() {
      currentIndex.value = pageController.page?.toInt() ?? 0;
    },);

    super.onInit();
  }

  @override
  void onClose() {
    pageController.removeListener(() {});
    pageController.dispose();
    super.onClose();
  }



}