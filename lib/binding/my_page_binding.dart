import 'package:get/get.dart';

import '../controller/controllers.dart';
import '../data/provider/providers.dart';
import '../data/repository/repositories.dart';

class MyPageBinding implements Bindings {

  @override
  void dependencies() {
    Get.lazyPut<AuthApi>(() => AuthApi());
    Get.lazyPut<MyPageRepository>(() => MyPageRepository(authApi: Get.find()),);
    Get.lazyPut<MyPageController>(() => MyPageController(myPageRepository: Get.find()),);
  }

}