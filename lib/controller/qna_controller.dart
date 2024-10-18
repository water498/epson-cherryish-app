import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:seeya/data/model/models.dart';
import 'package:seeya/data/repository/repositories.dart';
import 'package:seeya/view/common/loading_overlay.dart';

class QnaController extends GetxController with GetSingleTickerProviderStateMixin {

  final QnaRepository qnaRepository;

  QnaController({required this.qnaRepository});





  late TabController tabController;
  final List<Widget> tabs = [
    const Tab(
      text: '전체',
    ),
    const Tab(
      text: '이미지 편집',
    ),
    const Tab(
      text: '수령/반납',
    ),
    const Tab(
      text: '취소/환불/교환',
    ),
    const Tab(
      text: '장소',
    ),
  ];



  RxList<QnaItemModel> qnaList = <QnaItemModel>[].obs;







  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: tabs.length, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchQnaList();
    });
  }

  Future<void> fetchQnaList () async {
    try {
      CommonResponseModel commonResponse = await qnaRepository.fetchQnaListApi(50, "mobile");

      if(commonResponse.successModel != null){

        QnaResponseModel response = QnaResponseModel.fromJson(commonResponse.successModel!.content);
        var list = response.items.where((qna) => qna.isShow == true,).toList();
        list.sort((a, b) => a.updated_date.compareTo(b.updated_date),);
        qnaList.value = list;

      } else if(commonResponse.failModel != null) {

        if(commonResponse.statusCode == 422){
          Fluttertoast.showToast(msg: "알 수 없는 에러가 발생하였습니다. 다시 시도해주세요.");
          Logger().e("Validation Error");
        }

      }


    } catch (e, stackTrace){
      Logger().e("error ::: $e");
      Logger().e("stackTrace ::: $stackTrace");
    } finally {

    }
  }

}