import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:seeya/constants/app_router.dart';
import 'package:seeya/data/model/models.dart';
import 'package:seeya/data/repository/repositories.dart';
import 'package:seeya/view/common/loading_overlay.dart';

import '../constants/app_prefs_keys.dart';
import '../constants/app_secret.dart';
import '../service/services.dart';
import '../utils/utils.dart';
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
      Fluttertoast.showToast(msg: "모든 컷을 채워주세요!");
      return;
    }

    if(eventFilterList.isEmpty) return;

    showDialog(context: context, builder: (context) {
      return CommonDialog(
        needWarning: true,
        title: "이 단계 후\n바로 인쇄가 진행됩니다.",
        description: "프린터가 배치된 장소와 가까이 있어주세요. 지연된 수거에 의해 발생한\n분실은 책임지지 않습니다.",
        button01text: "앞으로 돌아가기",
        onButton01Click: () async {

        },
        button02text: "진행하기",
        onButton02Click: () async {
          await checkPrinterAccess();
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
          Fluttertoast.showToast(msg: "재출력 횟수를 모두 소진하셨습니다.");
        } else if (response.result == "need_payment"){
          // TODO
          Fluttertoast.showToast(msg: "먼저 결제를 완료해주세요."); // TODO
          // TODO
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



  Future<void> uploadFinalImage(int print_queue_id) async {
    try {
      LoadingOverlay.show("모든 이미지를 병합중입니다..");

      var resultFile = await ImageUtils.makeFinalFrameImage(
          eventFrame,
          mergedPhotoList,
          eventFilterList
      );

      if(resultFile == null) {
        Fluttertoast.showToast(msg: "이미지를 병합하는중 오류가 발생하였습니다.");
        return;
      }


      CommonResponseModel commonResponse = await decorateFrameRepository.uploadFinalImage(event.id, resultFile);

      if(commonResponse.successModel != null){

        String filepath = commonResponse.successModel!.content["filepath"];
        await requestPrintApi(filepath, print_queue_id);

      } else if(commonResponse.failModel != null){

        if(commonResponse.statusCode == 422){
          Fluttertoast.showToast(msg: "알 수 없는 에러가 발생하였습니다. 다시 시도해주세요.");
        }

      }

    } catch (e, stackTrace){
      Logger().e("error ::: $e");
      Logger().e("stackTrace ::: $stackTrace");
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

        LoadingOverlay.show("인쇄 요청중...", 1);
        await Future.delayed(const Duration(seconds: 3));
        showCompletedDialog(response.wait_count);

      } else if(commonResponse.failModel != null){

        if(commonResponse.statusCode == 409){
          Fluttertoast.showToast(msg: "이미 프린트 중입니다.");
        } else if(commonResponse.statusCode == 422){
          Fluttertoast.showToast(msg: "알 수 없는 에러가 발생하였습니다. 다시 시도해주세요.");
        }

      }

    } catch (e, stackTrace){
      Logger().e("error ::: $e");
      Logger().e("stackTrace ::: $stackTrace");
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
          title: "등록이 완료 되었습니다!\n대기번호 : ${waitCount}",
          button01text: "내역 확인하기",
          onButton01Click: () async {
            Get.toNamed(AppRouter.report);
          },
          button02text: "이벤트 페이지로 가기",
          onButton02Click: () async {
            Get.until((route) => Get.currentRoute == AppRouter.event_detail);
          },
        );
      },);
  }



}