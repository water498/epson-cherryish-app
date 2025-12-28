import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:logger/logger.dart';
import 'package:naver_login_sdk/naver_login_sdk.dart';
import 'package:seeya/core/data/model/auth/user_detail.dart';
import 'package:seeya/core/data/repository/auth_repository.dart';
import 'package:seeya/view/common/loading_overlay.dart';

// v1 (deprecated)
// import 'package:seeya/data/repository/repositories.dart';

import '../core/config/app_prefs_keys.dart';
import '../core/services/preference_service.dart';
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
    await AppPreferences().prefs?.remove(AppPrefsKeys.loginPlatform); // remove login platform
    UserService.instance.userDetail.value = null;

  }


}