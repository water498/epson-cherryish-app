import 'package:get/get.dart';

import '../controller/controllers.dart';

class MyPageBinding implements Bindings {

  @override
  void dependencies() {
    Get.lazyPut<MyPageController>(() => MyPageController());
  }

}