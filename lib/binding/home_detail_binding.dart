import 'package:get/get.dart';
import 'package:seeya/data/repository/repositories.dart';

import '../controller/controllers.dart';
import '../data/provider/providers.dart';

class HomeDetailBinding implements Bindings {

  @override
  void dependencies() {
    Get.lazyPut<HomeDetailApi>(() => HomeDetailApi());
    Get.lazyPut<HomeDetailRepository>(() => HomeDetailRepository(homeDetailApi: Get.find()));
    Get.lazyPut<HomeDetailController>(() => HomeDetailController(homeDetailRepository: Get.find()));
  }

}