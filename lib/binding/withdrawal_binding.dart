import 'package:get/get.dart';

import '../controller/controllers.dart';

class WithdrawalBinding implements Bindings {

  @override
  void dependencies() {
    Get.lazyPut<WithdrawalController>(() => WithdrawalController());
  }

}