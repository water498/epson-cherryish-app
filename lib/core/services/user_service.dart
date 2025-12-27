import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:seeya/core/services/preference_service.dart';
import '../config/app_prefs_keys.dart';
import '../data/model/auth/user_detail.dart';
import 'services.dart';

class UserService extends GetxService{

  // v2: Single UserDetail model instead of dual v1 models
  var userDetail = Rx<UserDetail?>(null);
  var isLoginUser = false.obs;
  var isDeveloperMode = false.obs;


  // Singleton
  static UserService get instance => Get.find();
  static void initialize() {Get.put(UserService());}


  @override
  void onInit() {
    super.onInit();

    final accessToken = AppPreferences().prefs?.getString(AppPrefsKeys.userAccessToken);
    if(userDetail.value != null && accessToken != null){
      isLoginUser(true);
    }else {
      isLoginUser(false);
    }

    ever(userDetail, (userInfo) {
      final accessToken = AppPreferences().prefs?.getString(AppPrefsKeys.userAccessToken);
      if(userInfo != null && accessToken != null){
        isLoginUser(true);
      }else {
        isLoginUser(false);
      }
    },);
  }



}