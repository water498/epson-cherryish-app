import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../data/model/models.dart';

class QrShareController extends GetxController{

  late EventModel eventModel;

  @override
  void onInit() {
    if(Get.arguments == null || Get.arguments is! EventModel) {
      Get.back();
      Fluttertoast.showToast(msg: "이벤트 정보를 불러오지 못 했습니다.");
      return;
    }
    eventModel = Get.arguments;
    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

}