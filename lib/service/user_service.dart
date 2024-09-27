import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../constants/app_prefs_keys.dart';
import '../data/model/models.dart';
import 'services.dart';

class UserService extends GetxService{

  var userInfo = Rx<UserInfoModel?>(null);
  var isLoginUser = false.obs;
  var isDeveloperMode = false.obs;


  // Singleton
  static UserService get instance => Get.find();
  static void initialize() {Get.put(UserService());}


  @override
  void onInit() {
    super.onInit();

    final accessToken = AppPreferences().prefs?.getString(AppPrefsKeys.userAccessToken);
    if(userInfo.value != null && accessToken != null){
      isLoginUser(true);
    }else {
      isLoginUser(false);
    }

    ever(userInfo, (userInfo) {
      final accessToken = AppPreferences().prefs?.getString(AppPrefsKeys.userAccessToken);
      if(userInfo != null && accessToken != null){
        isLoginUser(true);
      }else {
        isLoginUser(false);
      }
    },);
  }



}