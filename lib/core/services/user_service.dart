import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:seeya/core/services/preference_service.dart';
import '../config/app_prefs_keys.dart';
import '../../data/model/models.dart';
import 'services.dart';

class UserService extends GetxService{

  var userPublicInfo = Rx<UserPublicModel?>(null);
  var userPrivateInfo = Rx<UserPrivateModel?>(null);
  var isLoginUser = false.obs;
  var isDeveloperMode = false.obs;


  // Singleton
  static UserService get instance => Get.find();
  static void initialize() {Get.put(UserService());}


  @override
  void onInit() {
    super.onInit();

    final accessToken = AppPreferences().prefs?.getString(AppPrefsKeys.userAccessToken);
    if(userPublicInfo.value != null && accessToken != null){
      isLoginUser(true);
    }else {
      isLoginUser(false);
    }

    ever(userPublicInfo, (userInfo) {
      final accessToken = AppPreferences().prefs?.getString(AppPrefsKeys.userAccessToken);
      if(userInfo != null && accessToken != null){
        isLoginUser(true);
      }else {
        isLoginUser(false);
      }
    },);
  }



}