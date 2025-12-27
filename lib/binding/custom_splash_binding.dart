import 'package:get/get.dart';
import 'package:seeya/controller/controllers.dart';

// v1 (deprecated)
// import 'package:seeya/data/repository/repositories.dart';
// import '../data/provider/providers.dart';

class CustomSplashBinding extends Bindings{

  @override
  void dependencies() {
    // v2
    Get.put(CustomSplashController());
  }

}