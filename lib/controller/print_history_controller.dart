import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:seeya/data/model/models.dart';
import 'package:seeya/data/repository/repositories.dart';
import 'package:seeya/view/common/loading_overlay.dart';

class PrintHistoryController extends GetxController{

  final PrintHistoryRepository printHistoryRepository;

  PrintHistoryController({required this.printHistoryRepository});






  RxList<PrintHistoryModel> historyList = <PrintHistoryModel>[].obs;
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
      CommonResponseModel commonResponse = await printHistoryRepository.fetchPrintHistories();

      if(commonResponse.successModel != null){

        List<PrintHistoryModel> response = PrintHistoryModel.fromJsonList(commonResponse.successModel!.content["items"]);
        historyList.value = response;

      } else if(commonResponse.failModel != null){

      }


    } catch (e, stackTrace){
      Logger().e("error ::: $e");
      Logger().e("stackTrace ::: $stackTrace");
    } finally {
      isLoadFinish(true);
    }
  }

}