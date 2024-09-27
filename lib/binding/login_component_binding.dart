import 'package:get/get.dart';

import '../controller/controllers.dart';
import '../data/provider/providers.dart';
import '../data/repository/repositories.dart';

class LoginComponentBinding implements Bindings {

  @override
  void dependencies() {
    Get.lazyPut<AuthApi>(() => AuthApi());
    Get.lazyPut<LoginRepository>(() => LoginRepository(authApi: Get.find()));
    Get.lazyPut<LoginComponentController>(() => LoginComponentController(loginRepository: Get.find()));
    Get.put<LoginComponentController>(LoginComponentController(loginRepository: Get.find()));
  }

}