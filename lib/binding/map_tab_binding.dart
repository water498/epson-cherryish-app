import 'package:get/get.dart';
import 'package:seeya/data/provider/providers.dart';
import 'package:seeya/data/repository/repositories.dart';

import '../controller/controllers.dart';

class MapTabBinding implements Bindings {

  @override
  void dependencies() {

    Get.put(EventApi());
    Get.lazyPut<MapTabRepository>(() => MapTabRepository(eventApi: Get.find()),);
    Get.lazyPut<MapTabController>(() => MapTabController(mapTabRepository: Get.find()),);
  }

}