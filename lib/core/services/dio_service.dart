import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:seeya/core/config/app_prefs_keys.dart';
import 'package:seeya/core/config/app_router.dart';
import 'package:seeya/core/config/app_secret.dart';
import 'package:seeya/core/services/preference_service.dart';
import 'package:seeya/core/services/services.dart';

class DioService extends GetxService {
  static DioService get to => Get.find();

  late final Dio dio;

  Future<DioService> init() async {
    dio = Dio(
      BaseOptions(
        baseUrl: AppSecret.baseUrl,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 15),
        contentType: 'application/json',
        headers: {
          'api-key': AppSecret.apiKey,
        },
      ),
    );

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        final accessToken = AppPreferences().prefs?.getString(AppPrefsKeys.userAccessToken);
        if (accessToken != null) {
          options.headers['authorization'] = 'Bearer $accessToken';
        }

        Logger().d("REQUEST[${options.method}] => PATH: ${options.path}");
        Logger().d("HEADERS: ${options.headers}");
        Logger().d("BODY: ${options.data}");

        return handler.next(options);
      },
      onResponse: (response, handler) {
        Logger().d("RESPONSE[${response.statusCode}] => DATA: ${response.data}");
        return handler.next(response);
      },
      onError: (e, handler) {
        Logger().e("ERROR[${e.response?.statusCode}] => MESSAGE: ${e.message}");
        Logger().e("ERROR[${e.response?.statusCode}] => DATA: ${e.response?.data}");

        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout ||
            e.type == DioExceptionType.sendTimeout) {
          Fluttertoast.showToast(msg: "네트워크 연결 시간이 초과되었습니다. 다시 시도해주세요.");
        } else if (e.type == DioExceptionType.badResponse) {
          int? statusCode = e.response?.statusCode;
          String requestPath = e.requestOptions.path;

          if (statusCode != null) {
            _handleStatusCode(statusCode, requestPath);
          }
        } else if (e.type == DioExceptionType.cancel) {
          Fluttertoast.showToast(msg: "요청이 취소되었습니다.");
        } else if (e.type == DioExceptionType.unknown) {
          Fluttertoast.showToast(msg: "알 수 없는 에러가 발생하였습니다.");
        }

        return handler.next(e);
      },
    ));

    return this;
  }

  void _handleStatusCode(int statusCode, String requestPath) {
    switch (statusCode) {
      case 401:
        // 전화번호 인증 필요
        Get.toNamed(AppRouter.phone_verification);
        break;
      case 402:
        // 차단된 사용자
        Get.offAllNamed(AppRouter.block);
        break;
      case 403:
        // 토큰 만료/유효하지 않음
        UserService.instance.userDetail.value = null;
        AppPreferences().prefs?.remove(AppPrefsKeys.userAccessToken);

        // 토큰 검증 API인 경우는 로그인 화면으로 이동하지 않음
        if (requestPath != "/mobile/auth/validate/token" &&
            requestPath != "/mobile/auth/profile" &&
            requestPath != "/api/v1/mobile/auth/me") {
          Get.toNamed(AppRouter.login);
        }
        break;
      case 404:
        Fluttertoast.showToast(msg: 'toast.error404'.tr);
        break;
      case 500:
        Fluttertoast.showToast(msg: 'toast.error500'.tr);
        break;
      case 503:
        // 서버 점검
        Get.offAllNamed(AppRouter.server_maintenance);
        break;
    }
  }
}
