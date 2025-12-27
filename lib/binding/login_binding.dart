import 'package:get/get.dart';

import '../controller/controllers.dart';

class LoginBinding implements Bindings {

  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController());
  }

}