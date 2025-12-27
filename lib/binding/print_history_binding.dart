import 'package:get/get.dart';

import '../controller/controllers.dart';

class PrintHistoryBinding implements Bindings {

  @override
  void dependencies() {
    Get.lazyPut<PrintHistoryController>(() => PrintHistoryController());
  }

}