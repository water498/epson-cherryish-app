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
      onError: (e, handler) async {
        Logger().e("ERROR[${e.response?.statusCode}] => MESSAGE: ${e.message}");
        Logger().e("ERROR[${e.response?.statusCode}] => DATA: ${e.response?.data}");

        if (e.type == DioExceptionType.connectionTimeout ||
            e.type == DioExceptionType.receiveTimeout ||
            e.type == DioExceptionType.sendTimeout) {
          Fluttertoast.showToast(msg: 'toast.network_timeout'.tr);
        } else if (e.type == DioExceptionType.badResponse) {
          int? statusCode = e.response?.statusCode;
          String requestPath = e.requestOptions.path;

          if (statusCode != null) {
            await _handleStatusCode(statusCode, requestPath, e);
          }
        } else if (e.type == DioExceptionType.cancel) {
          Fluttertoast.showToast(msg: 'toast.request_cancelled'.tr);
        } else if (e.type == DioExceptionType.unknown) {
          Fluttertoast.showToast(msg: 'toast.unknown_error'.tr);
        }

        return handler.next(e);
      },
    ));

    return this;
  }

  Future<void> _handleStatusCode(int statusCode, String requestPath, DioException e) async {

    switch (statusCode) {
      case 401:
        // 전화번호 인증 필요 - 토큰 유효성 확인 후 처리
        final accessToken = AppPreferences().prefs?.getString(AppPrefsKeys.userAccessToken);
        if (accessToken != null && accessToken.isNotEmpty) {
          // auth/me API를 제외한 경우만 토큰 유효성 확인
          if (requestPath != "/api/v1/mobile/auth/me") {
            await _verifyTokenAndNavigate(accessToken);
          }
        }
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
      default:
        Fluttertoast.showToast(msg: e.response?.data['detail']);
        break;
    }
  }

  Future<void> _verifyTokenAndNavigate(String accessToken) async {
    try {
      // 별도의 Dio 인스턴스 생성 (인터셉터 없이)
      final authDio = Dio(BaseOptions(
        baseUrl: AppSecret.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        headers: {
          'api-key': AppSecret.apiKey,
          'authorization': 'Bearer $accessToken',
        },
      ));

      // auth/me API 호출로 토큰 유효성 확인
      await authDio.get('/api/v1/mobile/auth/me');

      // 토큰이 유효함 → 폰 인증 필요
      Get.toNamed(AppRouter.phone_verification);
    } catch (e) {
      // 토큰이 만료되었거나 유효하지 않음 → 로그인 화면으로
      Logger().e("Token validation failed: $e");
      UserService.instance.userDetail.value = null;
      AppPreferences().prefs?.remove(AppPrefsKeys.userAccessToken);
      Get.toNamed(AppRouter.login);
    }
  }
}
