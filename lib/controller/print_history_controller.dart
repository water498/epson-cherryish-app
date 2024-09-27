import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:seeya/view/common/loading_overlay.dart';

class PrintHistoryController extends GetxController{

  RxList<String> historyList = <String>[].obs;
  var isLoadFinish = false.obs;
  late final PageController pageController;


  @override
  void onInit() {
    pageController = PageController(
        initialPage: 0,
        viewportFraction: 0.9
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchHistory();
    });

    super.onInit();
  }

  @override
  void onClose() {
    pageController.dispose();
    super.onClose();
  }

  Future<void> fetchHistory() async {
    try {
      LoadingOverlay.show(null);

      await Future.delayed(Duration(milliseconds: 300));

      historyList.value = ["", ""];

    } catch (e, stackTrace){
      Logger().e("error ::: $e");
      Logger().e("stackTrace ::: $stackTrace");
    } finally {
      isLoadFinish(true);
      LoadingOverlay.hide();
    }
  }

}