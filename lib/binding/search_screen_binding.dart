import 'package:get/get.dart';

import '../controller/controllers.dart';
// v1 (deprecated)
// import '../data/provider/providers.dart';
// import '../data/repository/repositories.dart';

class SearchScreenBinding implements Bindings {

  @override
  void dependencies() {
    // v2
    Get.lazyPut<SearchScreenController>(() => SearchScreenController());
  }

}