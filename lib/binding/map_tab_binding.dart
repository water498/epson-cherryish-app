import 'package:get/get.dart';

// v1 (deprecated)
// import 'package:seeya/data/provider/providers.dart';
// import 'package:seeya/data/repository/repositories.dart';

import '../controller/controllers.dart';

class MapTabBinding implements Bindings {

  @override
  void dependencies() {
    // v2
    Get.lazyPut<MapTabController>(() => MapTabController());
  }

}