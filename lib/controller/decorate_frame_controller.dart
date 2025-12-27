import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:seeya/core/config/app_router.dart';
import 'package:seeya/data/model/models.dart';
import 'package:seeya/data/repository/repositories.dart';
import 'package:seeya/view/common/loading_overlay.dart';

import '../core/config/app_prefs_keys.dart';
import '../core/config/app_secret.dart';
import '../core/services/services.dart';
import '../core/utils/utils.dart';
import '../view/dialog/dialogs.dart';

class DecorateFrameController extends GetxController{

  final DecorateFrameRepository decorateFrameRepository;

  DecorateFrameController({required this.decorateFrameRepository});




  late EventModel event;
  late EventFrameModel eventFrame;
  late List<EventFilterModel> eventFilterList;
  var mergedPhotoList = <int,CameraResultModel?>{}.obs;


  @override
  void onInit() {

    event = Get.arguments["event"];
    eventFrame = Get.arguments["event_frame"];
    eventFilterList = Get.arguments["event_filters"];

    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }



  Future<void> printFinalFrame(BuildContext context) async {

    bool allPhotosCaptured = mergedPhotoList.values.where((value) => value != null).length == eventFilterList.length;
    if(!allPhotosCaptured){
      Fluttertoast.showToast(msg: "decorate_frame.toast.empty_cut".tr);
      return;
    }

    if(eventFilterList.isEmpty) return;

    showDialog(context: context, builder: (context) {
      return CommonDialog(
        needWarning: true,
        title: "decorate_frame_confirm_dialog.title".tr,
        description: "decorate_frame_confirm_dialog.description".tr,
        button01text: "decorate_frame_confirm_dialog.button01".tr,
        onButton01Click: () async {

        },
        button02text: "decorate_frame_confirm_dialog.button02".tr,
        onButton02Click: () async {

          if(event.payment_type == "postpayment"){

            if(UserService.instance.userPublicInfo.value == null){
              Fluttertoast.showToast(msg: "decorate_frame.toast.not_found_user".tr);
              return;
            }

            var resultPrintQueueId = await Get.toNamed(AppRouter.payment, arguments: {
              "event_id" : event.id,
              "user_id" : UserService.instance.userPublicInfo.value!.id,
              "s3_filepath" : null,
            });

            if(resultPrintQueueId == null || resultPrintQueueId == -1) {
              Fluttertoast.showToast(msg: "[Error] queue id is null");
              return;
            }

            await uploadFinalImage(resultPrintQueueId);
          } else {
            await checkPrinterAccess();
          }

        },
      );
    },);


  }





  Future<void> checkPrinterAccess () async {
    try {
      LoadingOverlay.show();

      CommonResponseModel commonResponse = await decorateFrameRepository.checkPrinterAccess(event.id);

      if(commonResponse.successModel != null){

        PrinterAccessResponseModel response = PrinterAccessResponseModel.fromJson(commonResponse.successModel!.content);

        if(response.result == "possible"){

          await uploadFinalImage(response.print_queue_id!);

        } else if (response.result == "already"){
          Fluttertoast.showToast(msg: "decorate_frame.toast.all_consumed".tr);
        } else {
          Fluttertoast.showToast(msg: "decorate_frame.toast.cant_user".tr);
        }

      } else if(commonResponse.failModel != null){

        if(commonResponse.statusCode == 409){
          Fluttertoast.showToast(msg: "decorate_frame.toast.already_finish".tr);
        } else {
          Fluttertoast.showToast(msg: "toast.unknown_error".tr);
        }

      }

    } catch (e, stackTrace){
      Logger().e("error ::: $e");
      Logger().e("stackTrace ::: $stackTrace");
      Fluttertoast.showToast(msg: "toast.unknown_error".tr);
    } finally {
      LoadingOverlay.hide();
    }
  }



  Future<void> uploadFinalImage(int print_queue_id) async {
    try {
      LoadingOverlay.show("loading.overlay04".tr);

      var resultFile = await ImageUtils.makeFinalFrameImage(
          eventFrame,
          mergedPhotoList,
          eventFilterList
      );

      if(resultFile == null) {
        Fluttertoast.showToast(msg: "decorate_frame.toast.merge_error".tr);
        return;
      }


      CommonResponseModel commonResponse = await decorateFrameRepository.uploadFinalImage(event.id, resultFile);


      if(commonResponse.successModel != null){

        String filepath = commonResponse.successModel!.content["filepath"];
        await requestPrintApi(filepath, print_queue_id);

      } else if(commonResponse.failModel != null){

        if(commonResponse.statusCode == 422){
          Fluttertoast.showToast(msg: "toast.unknown_error".tr);
        } else {
          Fluttertoast.showToast(msg: "toast.unknown_error".tr);
        }

      }

    } catch (e, stackTrace){
      Logger().e("error ::: $e");
      Logger().e("stackTrace ::: $stackTrace");
      Fluttertoast.showToast(msg: "toast.unknown_error".tr);
    } finally {
      LoadingOverlay.hide();
    }
  }



  Future<void> requestPrintApi (String filepath, int print_queue_id) async {
    try {
      LoadingOverlay.show();

      var request = {
        "print_filepath" : filepath,
        "event_id" : event.id,
        "print_queue_id" : print_queue_id,
      };

      CommonResponseModel commonResponse = await decorateFrameRepository.requestPrintApi(request);

      if(commonResponse.successModel != null){

        RequestPrintResponseModel response = RequestPrintResponseModel.fromJson(commonResponse.successModel!.content);

        LoadingOverlay.show("loading.overlay05".tr, 1);
        await Future.delayed(const Duration(seconds: 3));
        showCompletedDialog(response.wait_count);

      } else if(commonResponse.failModel != null){

        if(commonResponse.statusCode == 409){
          Fluttertoast.showToast(msg: "decorate_frame.toast.already_printing".tr);
        } else if(commonResponse.statusCode == 422){
          Fluttertoast.showToast(msg: "toast.unknown_error".tr);
        } else {
          Fluttertoast.showToast(msg: "toast.unknown_error".tr);
        }

      }

    } catch (e, stackTrace){
      Logger().e("error ::: $e");
      Logger().e("stackTrace ::: $stackTrace");
      Fluttertoast.showToast(msg: "toast.unknown_error".tr);
    } finally {
      LoadingOverlay.hide();
    }
  }



  void showCompletedDialog(int waitCount) {
    if(Get.context == null) return;
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (context) {
        return CommonDialog(
          title: "decorate_frame_complete_dialog.title".trParams({'waitCount':waitCount.toString()}),
          button01text: "decorate_frame_complete_dialog.button01".tr,
          onButton01Click: () async {
            Get.offNamed(AppRouter.report);
          },
          button02text: "decorate_frame_complete_dialog.button02".tr,
          onButton02Click: () async {
            Get.until((route) => Get.currentRoute == AppRouter.event_detail);
          },
        );
      },);
  }



}