import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:seeya/data/repository/repositories.dart';
import 'package:seeya/view/common/loading_overlay.dart';

import '../data/model/models.dart';
import '../view/dialog/dialogs.dart';
import 'controllers.dart';

class ErrorReportController extends GetxController{

  final ErrorReportRepository errorReportRepository;

  ErrorReportController({required this.errorReportRepository});




  late PrintHistoryModel printHistory;
  Rxn<File> selectedImage = Rxn<File>();
  late TextEditingController textController;
  late FocusNode focusNode;


  @override
  void onInit() {
    printHistory = Get.arguments;
    textController = TextEditingController();
    focusNode = FocusNode();
    super.onInit();
  }

  @override
  void onClose() {
    textController.dispose();
    focusNode.dispose();
    selectedImage.value = null;
    super.onClose();
  }


  Future<void> pickImage() async {

    try{
      var selectedXfile = await ImagePicker().pickImage(source: ImageSource.gallery);

      if(selectedXfile != null){
        selectedImage.value = File(selectedXfile.path);
      }

    }catch (e){
      if(Platform.isIOS){
        var status = await Permission.photos.status;
        if (status.isDenied) {
          Logger().d('Access Denied');
          openAppSettings();
        } else {
          Logger().e('Exception occured! ::: $e');
        }
      }
      return null;
    }

  }




  Future<void> uploadImage({required Function(String) onSuccess}) async {
    try {
      LoadingOverlay.show();

      CommonResponseModel commonResponse = await errorReportRepository.uploadReportImage(
          printHistory.event_id,
          File(selectedImage.value!.path)
      );

      if(commonResponse.successModel != null){

        String filepath = commonResponse.successModel!.content["filepath"];
        onSuccess(filepath);

      } else if(commonResponse.failModel != null) {

        if(commonResponse.statusCode == 409){
          Fluttertoast.showToast(msg: "error_report.toast.already_post".tr);
        }else if(commonResponse.statusCode == 422){
          Fluttertoast.showToast(msg: "toast.unknown_error".tr);
          Logger().e("Validation Error");
        }

      }

    } catch (e,stackTrace){
      Logger().e("error ::: $e");
      Logger().e("stackTrace ::: $stackTrace");
    } finally {
      LoadingOverlay.hide();
    }
  }



  Future<void> reportError({required String reportFilepath, required VoidCallback onSuccess}) async {

    try {
      LoadingOverlay.show();

      var request = ReportErrorRequestModel(
        printer_id: printHistory.printer_id,
        mobile_user_id: printHistory.mobile_user_id,
        partner_user_id: printHistory.partner_user_id,
        event_id: printHistory.event_id,
        event_name: printHistory.event_name,
        mobile_user_name: printHistory.mobile_user_name,
        mobile_user_phone_number: printHistory.mobile_user_phone_number,
        report_filepath: reportFilepath,
        report_reason: textController.text,
        print_filepath: printHistory.print_filepath,
        status: printHistory.status,
        printing_date: printHistory.printing_date,
      ).toJson();


      CommonResponseModel commonResponse = await errorReportRepository.requestReport(request);

      if(commonResponse.successModel != null){

        var result = commonResponse.successModel!.content["success"];

        // Success
        if(result is bool && result == true){
          onSuccess();
        }

      } else if(commonResponse.failModel != null) {

        if(commonResponse.statusCode == 422){
          Fluttertoast.showToast(msg: "toast.unknown_error".tr);
          Logger().e("Validation Error");
        }

      }

    } catch (e,stackTrace){
      Logger().e("error ::: $e");
      Logger().e("stackTrace ::: $stackTrace");
    } finally {
      LoadingOverlay.hide();
    }

  }




  void showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
      return CommonDialog(
        needAppBar: true,
        appBarText: "에러 리포트 완료",
        showAppbarClose: false,
        title: "에러 리포트가\n성공적으로 등록되었습니다.\n진행 상황은 문의 내역에서\n확인 부탁드립니다.",
        button01text: "확인",
        onButton01Click: () async {
          Get.back();
        },
        button02text: "문의 내역 확인하기",
        onButton02Click: () async {
          Get.back();
          Get.find<ReportController>().selectedTabIndex.value = 1;
        },
      );
    },);
  }





}