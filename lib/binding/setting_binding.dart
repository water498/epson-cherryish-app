import 'package:get/get.dart';

import '../controller/controllers.dart';
import '../data/provider/providers.dart';
import '../data/repository/repositories.dart';

class SettingBinding implements Bindings {

  @override
  void dependencies() {
    Get.lazyPut<AuthApi>(() => AuthApi());
    Get.lazyPut<SettingRepository>(() => SettingRepository(authApi: Get.find()),);
    // Get.lazyPut<SettingController>(() => SettingController(settingRepository: Get.find()),);
    Get.put(SettingController(settingRepository: Get.find()));
  }

}