import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:seeya/core/data/model/common/common_models.dart';
import 'package:seeya/core/data/repository/common_repository.dart';

class QnaController extends GetxController with GetSingleTickerProviderStateMixin {

  final commonRepository = CommonRepository();



  RxList<Qna> qnaList = <Qna>[].obs;







  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchQnaList();
    });
  }

  Future<void> fetchQnaList () async {
    try {
      // Get current language code
      final locale = Get.locale ?? Get.deviceLocale;
      final langCode = locale?.languageCode?.toUpperCase() ?? 'KO';

      // v2 API: Get QNA list with language code
      List<Qna> items = await commonRepository.getQnas(lang: langCode);

      // Filter by isShow and deletedDate
      var list = items.where((qna) =>
        qna.isShow == true && qna.deletedDate == null
      ).toList();

      // Sort by updatedDate
      list.sort((a, b) => a.updatedDate.compareTo(b.updatedDate));

      qnaList.value = list;

    } catch (e, stackTrace){
      Logger().e("error ::: $e");
      Logger().e("stackTrace ::: $stackTrace");
      Fluttertoast.showToast(msg: "toast.unknown_error".tr);
    }
  }

}