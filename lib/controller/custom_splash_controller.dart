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
      // v2 API
      UserDetail userDetail = await authRepository.getMe();

      // Convert UserDetail to UserPublicModel for compatibility
      UserPublicModel userPublic = UserPublicModel(
        id: userDetail.userId,
        name: userDetail.name,
        email: userDetail.email,
        profile_url: userDetail.profileUrl,
        fcm_token: userDetail.fcmToken,
        os_name: userDetail.osName,
        os_version: userDetail.osVersion,
        created_date: userDetail.createdDate ?? DateTime.now(),
        last_login_date: userDetail.lastLoginDate ?? DateTime.now(),
        deleted_date: userDetail.deletedDate,
        social_type: userDetail.socialType?.value ?? 'unknown',
      );

      UserService.instance.userPublicInfo.value = userPublic;

    } catch (e, stackTrace) {
      Logger().d("Error: $e");
      Logger().d("stackTrace: $stackTrace");
    }
  }



}