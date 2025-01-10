import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:seeya/data/repository/report_repository.dart';

import '../constants/app_router.dart';
import '../data/model/models.dart';
import '../service/services.dart';
import '../view/common/loading_overlay.dart';
import '../view/dialog/dialogs.dart';

class ReportController extends GetxController{

  final ReportRepository reportRepository;

  ReportController({required this.reportRepository});




  var selectedTabIndex = 0.obs;
  RxList<PrintHistoryModel> usageHistoryList = <PrintHistoryModel>[].obs;
  RxList<InquiryItemModel> inquiryList = <InquiryItemModel>[].obs;





  @override
  void onInit() {
    super.onInit();
    ever(selectedTabIndex, (index) {
      if(index == 0){
        fetchPrintHistories();
      } else if(index == 1){
        fetchReports();
      }
    },);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchPrintHistories();
    });
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }



  Future<void> fetchPrintHistories () async {
    try {
      CommonResponseModel commonResponse = await reportRepository.fetchPrintHistories();

      if(commonResponse.successModel != null){
        List<PrintHistoryModel> response = PrintHistoryModel.fromJsonList(commonResponse.successModel!.content["items"]);

        usageHistoryList.value = response;

      }

    } catch (e, stackTrace){
      Logger().e("error ::: $e");
      Logger().e("stackTrace ::: $stackTrace");
    } finally {

    }
  }



  Future<void> checkPrinterAccess (PrintHistoryModel printHistory) async {
    try {
      LoadingOverlay.show();

      CommonResponseModel commonResponse = await reportRepository.checkPrinterAccess(printHistory.event_id, printHistory.print_filepath);

      if(commonResponse.successModel != null){

        PrinterAccessResponseModel response = PrinterAccessResponseModel.fromJson(commonResponse.successModel!.content);

        if(response.result == "possible"){

          await requestPrintApi(response.print_queue_id!, printHistory);

        } else if (response.result == "already"){
          Fluttertoast.showToast(msg: "재출력 횟수를 모두 소진하셨습니다.");
        } else {
          Fluttertoast.showToast(msg: "현재 이용할 수 없는 상황입니다. 잠시 후에 다시 시도해주세요.");
        }

      } else if(commonResponse.failModel != null){

        if(commonResponse.statusCode == 409){
          Fluttertoast.showToast(msg: "이미 종료된 이벤트입니다.");
        }

      }

    } catch (e, stackTrace){
      Logger().e("error ::: $e");
      Logger().e("stackTrace ::: $stackTrace");
    } finally {
      LoadingOverlay.hide();
    }
  }



  Future<void> requestPrintApi (int printQueueId, PrintHistoryModel printHistory) async {
    try {
      LoadingOverlay.show("");

      var request = {
        "print_filepath" : printHistory.print_filepath,
        "event_id" : printHistory.event_id,
        "print_queue_id" : printQueueId,
      };

      CommonResponseModel commonResponse = await reportRepository.requestPrintApi(request);

      if(commonResponse.successModel != null){

        RequestPrintResponseModel response = RequestPrintResponseModel.fromJson(commonResponse.successModel!.content);

        LoadingOverlay.show("인쇄 요청중...", 1);
        await Future.delayed(const Duration(seconds: 3));
        showCompletedDialog(response.wait_count);

      } else if(commonResponse.failModel != null){

        if(commonResponse.statusCode == 409){
          Fluttertoast.showToast(msg: "이미 프린트 중입니다.");
        }

      }

    } catch (e, stackTrace){
      Logger().e("error ::: $e");
      Logger().e("stackTrace ::: $stackTrace");
    } finally {
      LoadingOverlay.hide();
    }
  }



  Future<void> fetchReports () async {
    try {
      CommonResponseModel commonResponse = await reportRepository.fetchReportsApi();

      if(commonResponse.successModel != null){
        List<InquiryItemModel> response = InquiryItemModel.fromJsonList(commonResponse.successModel!.content["items"]);

        inquiryList.value = response;

      }

    } catch (e, stackTrace){
      Logger().e("error ::: $e");
      Logger().e("stackTrace ::: $stackTrace");
    } finally {

    }
  }



  void showReprintAlert(BuildContext context, PrintHistoryModel printHistory) {
    showDialog(
      context: context,
      builder: (context) {
        return CommonDialog(
          showLine: true,
          needAppBar: true,
          appBarText: "재출력",
          showAppbarClose: true,
          title: "재출력은 1회까지만 가능합니다.",
          button01text: "취소",
          onButton01Click: () async {

          },
          button02text: "프린트 하기",
          onButton02Click: () async {

            if(printHistory.merchant_uid != "none"){
              if(UserService.instance.userPublicInfo.value == null){
                Fluttertoast.showToast(msg: "사용자 정보를 불러올 수 없습니다.");
                return;
              }

              var resultPrintQueueId = await Get.toNamed(AppRouter.payment, arguments: {
                "event_id" : printHistory.event_id,
                "user_id" : printHistory.mobile_user_id,
                "s3_filepath" : printHistory.print_filepath == null ? null : Uri.encodeFull("${printHistory.print_filepath}"),
              });

              if(resultPrintQueueId == null) return;

              await requestPrintApi(resultPrintQueueId, printHistory);
            } else {
              await checkPrinterAccess (printHistory);
            }



          },
        );
      },);
  }




  void showCompletedDialog(int waitCount) {
    if(Get.context == null) return;
    showDialog(
      context: Get.context!,
      builder: (context) {
        return CommonDialog(
          title: "등록이 완료 되었습니다!\n대기번호 : ${waitCount}",
          button01text: "확인",
          onButton01Click: () async {

          },
        );
      },);
  }


}