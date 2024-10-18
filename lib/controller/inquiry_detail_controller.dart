import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:seeya/data/model/models.dart';
import 'package:seeya/data/repository/repositories.dart';
import 'package:seeya/view/common/loading_overlay.dart';

class InquiryDetailController extends GetxController{

  final InquiryDetailRepository inquiryDetailRepository;

  InquiryDetailController({required this.inquiryDetailRepository});



  late int reportId;
  var isLoading = true.obs;
  InquiryItemModel? inquiryItem;


  @override
  void onInit() {
    reportId = Get.arguments;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchInquiryState();
    });
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }


  Future<void> fetchInquiryState() async {
    try {
      isLoading(true);
      CommonResponseModel commonResponse = await inquiryDetailRepository.fetchReportApi(reportId);

      if(commonResponse.successModel != null){

        InquiryItemModel response = InquiryItemModel.fromJson(commonResponse.successModel!.content["item"]);
        inquiryItem = response;

      } else if(commonResponse.failModel != null) {

        if(commonResponse.statusCode == 422){
          Fluttertoast.showToast(msg: "알 수 없는 에러가 발생하였습니다. 다시 시도해주세요.");
          Logger().e("Validation Error");
        }

      }

    } catch (e,stackTrace){
      Logger().e("error ::: $e");
      Logger().e("stackTrace ::: $stackTrace");
    } finally {
      isLoading(false);
    }
  }

}