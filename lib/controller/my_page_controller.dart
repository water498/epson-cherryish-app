import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_naver_login_plus/flutter_naver_login_plus.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:logger/logger.dart';
import 'package:seeya/data/repository/repositories.dart';
import 'package:seeya/view/common/loading_overlay.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../constants/app_prefs_keys.dart';
import '../constants/app_router.dart';
import '../data/enum/enums.dart';
import '../data/model/models.dart';
import '../service/services.dart';

class MyPageController extends GetxController {

  final MyPageRepository myPageRepository;

  MyPageController({required this.myPageRepository});




  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }







  Future<void> validateToken() async {
    try {
      CommonResponseModel commonResponse = await myPageRepository.fetchMyProfile();

      if(commonResponse.successModel != null){
        UserPrivateModel response = UserPrivateModel.fromJson(commonResponse.successModel!.content['item']);

        UserService.instance.userPublicInfo.value = response.userPublicModel;
        UserService.instance.userPrivateInfo.value = response;

      }

    } catch (e, stackTrace) {
      Logger().d("Error: $e");
      Logger().d("stackTrace: $stackTrace");
    } finally {

    }
  }





  void signOut() async {

    LoadingOverlay.show();
    await Future.delayed(const Duration(milliseconds: 400));
    LoadingOverlay.hide();

    String? loginPlatform = AppPreferences().prefs?.getString(AppPrefsKeys.loginPlatform);

    if(loginPlatform != null){
      switch (loginPlatform) {
        case 'google':
          await GoogleSignIn().signOut();
          break;
        case 'kakao':
          await UserApi.instance.logout();
          break;
        case 'naver':
          await FlutterNaverLoginPlus.logOut();
          break;
        case 'apple':
        case 'none':
          break;
      }
    }

    await FirebaseAuth.instance.signOut();
    await AppPreferences().prefs?.remove(AppPrefsKeys.userAccessToken); // remove access token
    await AppPreferences().prefs?.setString(AppPrefsKeys.loginPlatform, LoginPlatform.none.toDisplayString());
    UserService.instance.userPublicInfo.value = null;

  }


}