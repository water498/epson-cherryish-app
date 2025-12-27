import 'package:get/get.dart';

import '../controller/controllers.dart';
import '../data/provider/providers.dart';
import '../data/repository/repositories.dart';

class LoginComponentBinding implements Bindings {

  @override
  void dependencies() {
    // v1 (deprecated)
    // Get.lazyPut<AuthApi>(() => AuthApi());
    // Get.lazyPut<LoginRepository>(() => LoginRepository(authApi: Get.find()));

    // v2
    Get.put<LoginComponentController>(LoginComponentController());
  }

}