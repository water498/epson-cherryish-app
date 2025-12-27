import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:seeya/core/config/app_router.dart';
import '../core/config/app_prefs_keys.dart';
import '../core/services/preference_service.dart';
import '../data/model/models.dart';
import '../data/repository/repositories.dart';
import '../core/services/services.dart';

class CustomSplashController extends GetxController{

  final CustomSplashRepository customSplashRepository;

  CustomSplashController({required this.customSplashRepository});


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
      CommonResponseModel commonResponse = await customSplashRepository.validateTokenApi();

      if(commonResponse.successModel != null){
        ValidateTokenResponseModel response = ValidateTokenResponseModel.fromJson(commonResponse.successModel!.content);

        if(response.success){
          UserService.instance.userPublicInfo.value = response.user;
        }

      }

    } catch (e, stackTrace) {
      Logger().d("Error: $e");
      Logger().d("stackTrace: $stackTrace");
    } finally {

    }
  }



}