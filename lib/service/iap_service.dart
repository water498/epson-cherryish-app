import 'package:get/get.dart';

class IAPService extends GetxService{

  // Singleton
  static IAPService get instance => Get.find();
  static void initialize() {Get.put(IAPService());}

}