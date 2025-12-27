import 'package:get/get.dart';

import '../controller/controllers.dart';

class RootBinding implements Bindings {

  @override
  void dependencies() {
    Get.put<RootController>(RootController());
  }

}