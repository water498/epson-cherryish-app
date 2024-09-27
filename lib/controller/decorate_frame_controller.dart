import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:seeya/data/model/models.dart';
import 'package:seeya/view/common/loading_overlay.dart';

import '../constants/app_prefs_keys.dart';
import '../constants/app_secret.dart';
import '../service/services.dart';
import '../utils/utils.dart';

class DecorateFrameController extends GetxController{

  late TempEvent event;
  late TempEventFrame eventFrame;
  late List<TempEventFilter> eventFilterList;
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



  Future<void> printFinalFrame() async {

    bool allPhotosCaptured = mergedPhotoList.values.where((value) => value != null).length == eventFilterList.length;
    if(!allPhotosCaptured){
      return;
    }

    if(eventFilterList.isEmpty) return;

    LoadingOverlay.show("이미지를 병합중입니다..");


    var resultFile = await ImageUtils.makeFinalFrameImage(
        eventFrame,
        mergedPhotoList,
        eventFilterList
    );
    LoadingOverlay.hide();

    if(resultFile != null){
      bool result = await requestPrint(resultFile);
      if(result) {
        Fluttertoast.showToast(msg: "프린트가 곧 시작됩니다 !", toastLength: Toast.LENGTH_LONG);
      }
    }

  }




  Future<bool> requestPrint(File file) async {
    try {
      LoadingOverlay.show("프린트를 요청 중입니다..");

      var request = http.MultipartRequest("POST", Uri.parse("${AppSecret.baseUrl}/public/test/print"));

      request.headers['api-key'] = AppSecret.apiKey;
      final token = AppPreferences().prefs?.getString(AppPrefsKeys.userAccessToken) ?? "";
      request.headers['authorization'] = 'Bearer $token';

      if(token.isEmpty){
        return false;
      }

      request.files.add(await http.MultipartFile.fromPath('file', file.path));

      var response = await request.send();

      Logger().d("response code ::: ${response.statusCode}");

      if(response.statusCode >= 200 && response.statusCode < 300){
        String responseBody = await response.stream.bytesToString();
        dynamic jsonData = jsonDecode(responseBody);

        Logger().d("jsonData ::: ${jsonData}");

        bool result = jsonData['success'];

        return result;
      }else {
        return false;
      }
    } catch (e, stackTrace) {
      Logger().e("error ::: $e");
      Logger().e("stackTrace: ${stackTrace}");
      return false;
    } finally {
      LoadingOverlay.hide();
    }
  }


}