import 'package:get/get.dart';

import '../controller/controllers.dart';
import '../data/provider/providers.dart';
import '../data/repository/repositories.dart';

class PhoneVerificationBinding implements Bindings {

  @override
  void dependencies() {
    Get.lazyPut<AuthApi>(() => AuthApi());
    Get.lazyPut<PhoneVerificationRepository>(() => PhoneVerificationRepository(authApi: Get.find()));
    Get.lazyPut<PhoneVerificationController>(() => PhoneVerificationController(phoneVerificationRepository: Get.find()));
  }

}