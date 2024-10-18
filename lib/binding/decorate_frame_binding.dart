import 'package:get/get.dart';

import '../controller/controllers.dart';
import '../data/provider/providers.dart';
import '../data/repository/repositories.dart';

class DecorateFrameBinding implements Bindings {

  @override
  void dependencies() {
    Get.lazyPut<PrinterApi>(() => PrinterApi());
    Get.lazyPut<DecorateFrameRepository>(() => DecorateFrameRepository(printerApi: Get.find()),);
    Get.lazyPut<DecorateFrameController>(() => DecorateFrameController(decorateFrameRepository: Get.find()),);
  }

}