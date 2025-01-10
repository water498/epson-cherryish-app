import 'package:get/get.dart';
import 'package:seeya/controller/controllers.dart';

class PaymentBinding implements Bindings {

  @override
  void dependencies() {
    Get.put<PaymentController>(PaymentController());
  }

}