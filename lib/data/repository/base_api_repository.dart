import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:seeya/constants/app_router.dart';

import '../../constants/app_prefs_keys.dart';
import '../../service/services.dart';
import '../model/models.dart';

class BaseApiRepository extends GetxService {

  Future<CommonResponseModel> handleApiResponse(Future<Response> apiCall) async {
    try {
      Response res = await apiCall;
      String requestPath = res.request?.url.path ?? "";

      Logger().d("requestPath :::::: ${requestPath}");

      // Fluttertoast.showToast(msg: "BaseRepository response \nstatus :::: ${res.statusCode}\n\nbody ::::   ${jsonEncode(res.body)}");
      Logger().d('BaseRepository response \nstatus :::: ${res.statusCode}\n\nbody ::::   ${jsonEncode(res.body)}');

      if (res.statusCode != null && res.statusCode! >= 200 && res.statusCode! < 300) {
        return CommonResponseModel(
          successModel: CommonSuccessModel.fromJson(res.body),
          statusCode: res.statusCode
        );
      } else {

        bool hasCommonError = await _handleCommonError(res.statusCode, requestPath);

        return CommonResponseModel(
          failModel: hasCommonError ? null : CommonFailModel.fromJson(res.body),
          statusCode: res.statusCode
        );
      }
    } catch (e) {
      Logger().d("ERROR: $e");
      rethrow;
    }
  }



  Future<bool> _handleCommonError(int? statusCode, String requestPath) async {
    bool hasError = false;

    final errorHandlers = {
      401: () {
        Get.toNamed(AppRouter.phone_verification);
      },
      402: () {
        Fluttertoast.showToast(msg: '관리자에 의해 차단되었습니다.');
      },
      403: () async {
        UserService.instance.userInfo.value = null;
        await AppPreferences().prefs?.remove(AppPrefsKeys.userAccessToken); // remove access token
        if(requestPath == "/mobile/auth/validate/token"){
          return;
        }
        Get.toNamed(AppRouter.login);
      },
      404: () {
        Fluttertoast.showToast(msg: '요청하신 리소스를 찾을 수 없습니다.');
      },
      500: () {
        Fluttertoast.showToast(msg: '처리중 알 수 없는 에러가 발생하였습니다.');
      },
    };

    if (errorHandlers.containsKey(statusCode)) {
      errorHandlers[statusCode]!(); // 해당 함수 실행
      hasError = true;
    }

    return hasError;
  }



}
