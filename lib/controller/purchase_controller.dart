import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:seeya/data/model/printer_model.dart';
import 'package:seeya/data/repository/repositories.dart';

import '../data/model/models.dart';

class PurchaseController extends GetxController{

  final PurchaseRepository purchaseRepository;

  PurchaseController({required this.purchaseRepository});


  MergedProductResponseModel? photoProduct;
  var isLoading = false.obs;
  var copiesCount = 1.obs;




  @override
  void onInit() {
    if(Get.arguments == null){
      Get.snackbar("⚠️", "알 수 없는 에러가 발생하였습니다.[error 5001]",colorText: Colors.white);
      Get.back();
      return;
    }
    photoProduct = Get.arguments["photo_product"];
    super.onInit();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }




  void requestPint(PrinterRequestModel request) async {

    try {
      isLoading(true);

      CommonResponseModel commonResponse = await purchaseRepository.requestPrintApi(request.toJson());

      if(commonResponse.successModel != null){

        Logger().d("commonResponse.successModel!.content ::: ${commonResponse.successModel!.content}");

        // PrinterResponseModel response = PrinterResponseModel.fromJson(commonResponse.successModel!.content);
        // productList.value = response;

        Fluttertoast.showToast(msg: "프린터 작업 목록에 추가되었습니다.\n곧 출력이 진행됩니다.");
        Get.back();


      } else if (commonResponse.statusCode == 410){
        Get.snackbar('프린터가 사용할 수 없는 상태입니다.', '[error code : ${410}]', colorText: Colors.white);
      } else if (commonResponse.statusCode == 411){
        Get.snackbar('이미 출력한 사진입니다.', '[error code : ${411}]', colorText: Colors.white);
      } else {
        Get.snackbar("⚠️", '알 수 없는 오류가 발생하였습니다', colorText: Colors.white);
      }

    } catch (e, stackTrace) {
      Get.snackbar("⚠️", '알 수 없는 오류가 발생하였습니다', colorText: Colors.white);
      Logger().d("Error: $e");
      Logger().d("stackTrace: $stackTrace");
    }finally {
      isLoading(false);
    }

  }




}