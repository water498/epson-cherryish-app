import 'package:get/get.dart';

import '../controller/controllers.dart';
import '../data/provider/providers.dart';
import '../data/repository/repositories.dart';

class PrintHistoryBinding implements Bindings {

  @override
  void dependencies() {
    Get.lazyPut<PrinterApi>(() => PrinterApi());
    Get.lazyPut<PrintHistoryRepository>(() => PrintHistoryRepository(printerApi: Get.find()),);
    Get.lazyPut<PrintHistoryController>(() => PrintHistoryController(printHistoryRepository: Get.find()),);
  }

}