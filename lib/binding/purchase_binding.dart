import 'package:get/get.dart';
import 'package:seeya/controller/controllers.dart';

import '../data/provider/providers.dart';
import '../data/repository/repositories.dart';

class PurchaseBinding implements Bindings {

  @override
  void dependencies() {
    Get.lazyPut<PrinterApi>(() => PrinterApi());
    Get.lazyPut<PurchaseRepository>(() => PurchaseRepository(printerApi: Get.find()));
    Get.lazyPut<PurchaseController>(() => PurchaseController(purchaseRepository: Get.find()));
  }

}