import 'package:get/get.dart';

import '../controller/controllers.dart';
import '../data/provider/providers.dart';
import '../data/repository/repositories.dart';

class WithdrawalBinding implements Bindings {

  @override
  void dependencies() {
    // v1 (deprecated)
    // Get.lazyPut<AuthApi>(() => AuthApi());
    // Get.lazyPut<WithdrawalRepository>(() => WithdrawalRepository(authApi: Get.find()),);

    // v2
    Get.lazyPut<WithdrawalController>(() => WithdrawalController());
  }

}