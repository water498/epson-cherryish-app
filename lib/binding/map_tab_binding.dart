import 'package:get/get.dart';

import '../controller/controllers.dart';

class MapTabBinding implements Bindings {

  @override
  void dependencies() {
    Get.lazyPut(() => MapTabController(),);
    // Get.put(MapTabController());
  }

}