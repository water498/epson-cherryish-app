import 'package:get/get.dart';

import '../controller/controllers.dart';
import '../data/provider/providers.dart';
import '../data/repository/repositories.dart';

class WithdrawalBinding implements Bindings {

  @override
  void dependencies() {
    Get.lazyPut<AuthApi>(() => AuthApi());
    Get.lazyPut<WithdrawalRepository>(() => WithdrawalRepository(authApi: Get.find()),);
    Get.lazyPut<WithdrawalController>(() => WithdrawalController(withdrawalRepository: Get.find()),);
  }

}