import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:seeya/view/common/loading_overlay.dart';

class InquiryDetailController extends GetxController{



  @override
  void onInit() {
    // TODO: implement onInit
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchInquiryState();
    });
    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }


  Future<void> fetchInquiryState() async {

    try {
      LoadingOverlay.show(null);

      await Future.delayed(Duration(milliseconds: 500));

    } catch(e){

    } finally {
      LoadingOverlay.hide();
    }


  }

}