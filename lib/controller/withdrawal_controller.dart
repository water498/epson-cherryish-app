import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_naver_login_plus/flutter_naver_login_plus.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:kakao_flutter_sdk_user/kakao_flutter_sdk_user.dart';
import 'package:logger/logger.dart';
import 'package:seeya/data/repository/repositories.dart';

import '../constants/app_prefs_keys.dart';
import '../constants/app_router.dart';
import '../data/enum/enums.dart';
import '../data/model/models.dart';
import '../service/services.dart';
import '../view/common/loading_overlay.dart';

class WithdrawalController extends GetxController{

  final WithdrawalRepository withdrawalRepository;

  WithdrawalController({required this.withdrawalRepository});



  var isAgree = false.obs;







  Future<void> withdraw() async {

    try {
      LoadingOverlay.show();

      CommonResponseModel commonResponse = await withdrawalRepository.withdrawalApi();

      if(commonResponse.successModel != null){

        bool isSuccess = commonResponse.successModel!.content["success"];

        if(isSuccess) {
          signOut();
        } else {
          Fluttertoast.showToast(msg: "알 수 없는 에러가 발생하였습니다. 다시 시도해주세요.");
        }

      }

    } catch (e, stackTrace){
      Logger().e("error ::: $e");
      Logger().e("stackTrace ::: $stackTrace");
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


    Get.offAllNamed(AppRouter.custom_splash);

  }

}