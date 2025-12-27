import 'package:get/get.dart';

import '../controller/controllers.dart';

class DecorateFrameBinding implements Bindings {

  @override
  void dependencies() {
    Get.lazyPut<DecorateFrameController>(() => DecorateFrameController());
  }

}