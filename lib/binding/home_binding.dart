import 'package:get/get.dart';
import 'package:seeya/data/provider/providers.dart';

import '../controller/controllers.dart';
import '../data/repository/repositories.dart';

class HomeBinding implements Bindings {

  @override
  void dependencies() {
    Get.lazyPut<HomeApi>(() => HomeApi());
    Get.lazyPut<HomeRepository>(() => HomeRepository(homeApi: Get.find()));
    Get.lazyPut<HomeController>(() => HomeController(homeRepository: Get.find()));
  }

}