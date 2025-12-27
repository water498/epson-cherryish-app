import 'package:get/get.dart';

import '../controller/controllers.dart';

class CameraBinding implements Bindings {

  @override
  void dependencies() {
    Get.lazyPut<CameraScreenController>(() => CameraScreenController());
  }

}