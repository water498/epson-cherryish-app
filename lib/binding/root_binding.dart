import 'package:get/get.dart';
import 'package:seeya/data/provider/providers.dart';

import '../controller/controllers.dart';
import '../data/repository/repositories.dart';

class RootBinding implements Bindings {

  @override
  void dependencies() {
    Get.put<RootController>(RootController());
  }

}