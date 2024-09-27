import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class SearchScreenController extends GetxController{


  late final TextEditingController textController;
  var searchText = ''.obs;
  late Function() textListener;



  @override
  void onInit() {
    textController = TextEditingController();
    textListener = () {
      searchText.value = textController.text;
      // TODO search api
    };
    textController.addListener(textListener);
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
    textController.removeListener(textListener);
    textController.dispose();
  }

}