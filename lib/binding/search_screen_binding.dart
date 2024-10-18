import 'package:get/get.dart';

import '../controller/controllers.dart';
import '../data/provider/providers.dart';
import '../data/repository/repositories.dart';

class SearchScreenBinding implements Bindings {

  @override
  void dependencies() {
    Get.lazyPut<SearchApi>(() => SearchApi());
    Get.lazyPut<SearchScreenRepository>(() => SearchScreenRepository(searchApi: Get.find()),);
    Get.lazyPut<SearchScreenController>(() => SearchScreenController(searchScreenRepository: Get.find()),);
  }

}