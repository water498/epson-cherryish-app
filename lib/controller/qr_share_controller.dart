import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../core/data/model/event/event.dart';

class QrShareController extends GetxController{

  late Event event;

  @override
  void onInit() {
    if(Get.arguments == null || Get.arguments is! Event) {
      Get.back();
      Fluttertoast.showToast(msg: "share.toast.event_not_found".tr);
      return;
    }
    event = Get.arguments;
    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

}