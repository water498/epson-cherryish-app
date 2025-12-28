import 'package:get/get.dart';

import '../controller/controllers.dart';

class PhoneVerificationBinding implements Bindings {

  @override
  void dependencies() {
    Get.put<PhoneVerificationController>(PhoneVerificationController());
  }

}