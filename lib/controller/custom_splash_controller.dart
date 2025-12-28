import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:seeya/core/config/app_router.dart';
import 'package:seeya/core/data/model/auth/user_detail.dart';
import 'package:seeya/core/data/repository/auth_repository.dart';
import '../core/config/app_prefs_keys.dart';
import '../core/services/preference_service.dart';
import '../data/model/models.dart';
// v1 (deprecated)
// import '../data/repository/repositories.dart';
import '../core/services/services.dart';

class CustomSplashController extends GetxController{

  final authRepository = AuthRepository();


  @override
  void onInit() {
    super.onInit();
    _initApp();
  }

  void _initApp() async {

    // fcm token fcm token fcm token fcm token fcm token fcm token---------------------------------------------
    if(Platform.isIOS){
      String? apnsToken = await FirebaseMessaging.instance.getAPNSToken();
      if (apnsToken == null) {
        Logger().d("APNS token is not set yet");
        await Future.delayed(const Duration(seconds: 1)); // apns 콜백 받고 getToken을 호출해야되는데 따로 콜백이 없음 stackoverflow 대처
        apnsToken = await FirebaseMessaging.instance.getAPNSToken();
      } else {
        await Future.delayed(const Duration(milliseconds: 800));
        Logger().d("APNS token: ${apnsToken}");
      }
    } else {
      await Future.delayed(const Duration(milliseconds: 800));
    }

    String? fcmToken = await FirebaseMessaging.instance.getToken();
    Logger().d("fcmToken ::: ${fcmToken}");

    AppPreferences().prefs?.setString(AppPrefsKeys.fcmToken, fcmToken ?? ""); // fcmToken 삽입
    // fcm token fcm token fcm token fcm token fcm token fcm token---------------------------------------------


    await validateToken();

    Get.offNamed(AppRouter.root);

  }


  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }



  Future<void> validateToken() async {
    try {
      // accessToken이 없으면 API 호출하지 않음 (비로그인 상태)
      final accessToken = AppPreferences().prefs?.getString(AppPrefsKeys.userAccessToken);
      if (accessToken == null || accessToken.isEmpty) {
        return;
      }

      // v2 API: Get user details and store directly
      UserDetail userDetail = await authRepository.getMe();
      UserService.instance.userDetail.value = userDetail;

    } catch (e, stackTrace) {
      Logger().d("Error: $e");
      Logger().d("stackTrace: $stackTrace");
    }
  }



}