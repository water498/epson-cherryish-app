import 'package:get/get.dart';

import '../controller/controllers.dart';

class QnaBinding implements Bindings {

  @override
  void dependencies() {
    Get.lazyPut<QnaController>(() => QnaController());
  }

}