import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:seeya/data/model/models.dart';
import 'package:seeya/view/common/loading_overlay.dart';

class QnaController extends GetxController with GetSingleTickerProviderStateMixin {

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
  RxList<QnaModel> qnaList = <QnaModel>[].obs;

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
      LoadingOverlay.show(null);
      // await Future.delayed(const Duration(milliseconds: 300));

      qnaList.value = [
        QnaModel(question: "시야 서비스가 뭔가요?", answer: "‘내 손안에 포토부스’ 시야는 포토부스를 업장 내, 행사 내에 대여하여 설치하고 싶었지만 높은 비용, 큰 기계 부피, 커스터마이징 불가능한 인화지 등 여러가지 문제 때문에 어려웠던 분들을 위한 서비스입니다."),
        QnaModel(question: "인화지가 이상하게 출력이 되었어요. 환불 가능한가요?", answer: "모바일 앱 내 ‘마이페이지’의 이용내역에서 에러나 났던 개별 건들에 대한 에러 리포트 및 환불 요청이 가능합니다."),
        QnaModel(question: "동일한 사진을 여러장 뽑는 것도 가능한가요?", answer: "이벤트 주최자가 미리 비용을 결제한 경우, ‘마이페이지’ 내 ‘에러 리포트’에서 최대 1장 더 출력이 가능합니다. 인화하실 때 결제를 하셨던 후결제의 경우 ‘에러 리포트’ 내 ‘재출력’ 버튼을 누른 후 추가 결제를 하시면 추가 인화가 가능합니다."),
        QnaModel(question: "찾으려는 이벤트가 앱 내에서 안 보여요!", answer: "이벤트 주최자가 해당 정보를 앱 내에서 비공개 처리한 경우 앱 내에 표시되지 않습니다. 이벤트 주최자에게 전달된 QR코드를 읽으시면 해당 이벤트에 할당된 정보에 접근 가능합니다."),
        QnaModel(question: "이벤트 장소 근처에 없어도 출력이 가능한가요?", answer: "최대한 프린터 근거리에 있을 경우에만 출력하는 것을 추천드립니다. 수령이 지연되어 사진이 분실된 경우 ‘시야’ 측과 주최측은 책임지지 않습니다. 또한 타인의 이용을 방해하는 목적을 가진 ‘어뷰징 유저’ 로 신고될 경우, 추후 시야 서비스를 이용하실 수 없습니다."),
      ];

    } catch (e, stackTrace){
      Logger().e("error ::: $e");
      Logger().e("stackTrace ::: $stackTrace");
    } finally {
      LoadingOverlay.hide();
    }
  }

}