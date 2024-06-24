import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../constants/app_prefs_keys.dart';
import '../constants/app_router.dart';
import '../data/enum/enums.dart';
import '../service/services.dart';

class MyPageController extends GetxController{


  void signOut() async {
    String? loginPlatform = AppPreferences().prefs?.getString(AppPrefsKeys.loginPlatform);

    if(loginPlatform != null){
      switch (loginPlatform) {
        case 'google':
          await GoogleSignIn().signOut();
          break;
        case 'kakao':
          break;
        case 'naver':
          break;
        case 'apple':
        case 'none':
          break;
      }
    }

    AppPreferences().prefs?.remove(AppPrefsKeys.userId); // remove user uid
    AppPreferences().prefs?.remove(AppPrefsKeys.userAccessToken); // remove access token
    AppPreferences().prefs?.setString(AppPrefsKeys.loginPlatform, LoginPlatform.none.toDisplayString());


    Get.offAllNamed(AppRouter.login);
  }


}