import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:logger/logger.dart';
import 'package:naver_login_sdk/naver_login_sdk.dart';
import 'package:seeya/core/data/repository/auth_repository.dart';
import 'package:seeya/data/repository/repositories.dart';

import '../core/config/app_prefs_keys.dart';
import '../core/config/app_router.dart';
import '../core/services/preference_service.dart';
import '../data/enum/enums.dart';
import '../data/model/models.dart';
import '../core/services/services.dart';
import '../view/common/loading_overlay.dart';

class WithdrawalController extends GetxController{

  final authRepository = AuthRepository();



  var isAgree = false.obs;







  Future<void> withdraw() async {

    try {
      LoadingOverlay.show();

      await authRepository.withdraw();

      // 회원탈퇴 성공
      signOut();

    } catch (e, stackTrace){
      Logger().e("error ::: $e");
      Logger().e("stackTrace ::: $stackTrace");
      Fluttertoast.showToast(msg: "toast.unknown_error".tr);
    } finally {
      LoadingOverlay.hide();
    }

  }










  void signOut() async {

    LoadingOverlay.show();
    await Future.delayed(const Duration(milliseconds: 500));
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


    Get.offAllNamed(AppRouter.custom_splash);

  }

}