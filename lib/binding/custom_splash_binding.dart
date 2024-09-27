import 'package:get/get.dart';
import 'package:seeya/controller/controllers.dart';
import 'package:seeya/data/repository/repositories.dart';

import '../data/provider/providers.dart';

class CustomSplashBinding extends Bindings{

  @override
  void dependencies() {
    Get.lazyPut<AuthApi>(() => AuthApi());
    Get.lazyPut<CustomSplashRepository>(() => CustomSplashRepository(authApi: Get.find()));
    Get.put(CustomSplashController(customSplashRepository: Get.find()));
  }

}