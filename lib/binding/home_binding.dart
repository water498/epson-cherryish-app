import 'package:get/get.dart';
import 'package:seeya/data/provider/providers.dart';

import '../controller/controllers.dart';
import '../data/repository/repositories.dart';

class HomeBinding implements Bindings {

  @override
  void dependencies() {
    // v1 (deprecated)
    // Get.lazyPut<HomeApi>(() => HomeApi());
    // Get.lazyPut<HomeRepository>(() => HomeRepository(homeApi: Get.find()));

    // v2
    Get.lazyPut<HomeController>(() => HomeController());
  }

}