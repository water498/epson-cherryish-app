import 'package:get/get.dart';

import '../controller/controllers.dart';
import '../data/provider/providers.dart';
import '../data/repository/repositories.dart';

class LoginBinding implements Bindings {

  @override
  void dependencies() {
    Get.lazyPut<AuthApi>(() => AuthApi());
    Get.lazyPut<LoginRepository>(() => LoginRepository(authApi: Get.find()));
    Get.lazyPut<LoginController>(() => LoginController(loginRepository: Get.find()));
  }

}