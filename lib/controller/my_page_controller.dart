import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:logger/logger.dart';
import 'package:naver_login_sdk/naver_login_sdk.dart';
import 'package:seeya/core/data/model/auth/user_detail.dart';
import 'package:seeya/core/data/repository/auth_repository.dart';
import 'package:seeya/view/common/loading_overlay.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

// v1 (deprecated)
// import 'package:seeya/data/repository/repositories.dart';

import '../core/config/app_prefs_keys.dart';
import '../core/config/app_router.dart';
import '../core/services/preference_service.dart';
import '../data/enum/enums.dart';
import '../data/model/models.dart';
import '../core/services/services.dart';

class MyPageController extends GetxController {

  final authRepository = AuthRepository();




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
      // v2 API
      UserDetail userDetail = await authRepository.getMe();

      // Convert UserDetail to existing model structure for compatibility
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

      UserPrivateModel userPrivate = UserPrivateModel(
        userPublicModel: userPublic,
        phone_number: userDetail.phoneNumber ?? '',
        phone_number_verification_date: userDetail.phoneNumberVerificationDate ?? DateTime.now(),
        social_id: userDetail.socialId ?? '',
      );

      UserService.instance.userPublicInfo.value = userPrivate.userPublicModel;
      UserService.instance.userPrivateInfo.value = userPrivate;

    } catch (e, stackTrace) {
      Logger().d("Error: $e");
      Logger().d("stackTrace: $stackTrace");
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
          try {
            await UserApi.instance.logout();
          } catch (e) {
            Logger().e("kakao logout error ::: $e");
          }
          break;
        case 'naver':
          try {
            await NaverLoginSDK.release();
          } catch (e) {
            Logger().e("naver logout error ::: $e");
          }
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