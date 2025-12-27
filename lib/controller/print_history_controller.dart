import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:seeya/core/data/model/print/print_models.dart';
import 'package:seeya/core/data/repository/print_repository.dart';

class PrintHistoryController extends GetxController{

  final printRepository = PrintRepository();






  RxList<PrintQueueItem> historyList = <PrintQueueItem>[].obs;
  var isLoadFinish = false.obs;
  late final PageController pageController;

  static const int limit = 100; // 한 번에 가져올 항목 수


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
      // v2 API: Get print queue items
      PrintQueueResponse response = await printRepository.getPrintQueues(
        skip: 0,
        limit: limit,
      );

      historyList.value = response.items;

    } catch (e, stackTrace){
      Logger().e("error ::: $e");
      Logger().e("stackTrace ::: $stackTrace");
      Fluttertoast.showToast(msg: "toast.unknown_error".tr);
    } finally {
      isLoadFinish(true);
    }
  }

}