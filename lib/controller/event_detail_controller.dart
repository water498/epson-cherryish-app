import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../data/model/models.dart';
import '../view/common/loading_overlay.dart';

class EventDetailController extends GetxController{

  double backgroundRatio = 0.9;

  int eventId = -1;
  late final ScrollController scrollController;
  var isAppBarExpanded = true.obs;

  Rxn<TempEvent> event = Rxn<TempEvent>();
  RxList<TempEventFrame> eventFrameList = <TempEventFrame>[].obs;
  RxList<TempEventFilter> eventFilterList = <TempEventFilter>[].obs;


  @override
  void onInit() {

    if (Get.arguments is int) {
      eventId = Get.arguments as int;
    }

    if (eventId == -1){
      Fluttertoast.showToast(msg: "이벤트 정보를 불러오지 못했습니다.");
    } else {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        fetchEventDetail(eventId);
      });
    }



    scrollController = ScrollController();
    scrollController.addListener(() {
      if (scrollController.hasClients && scrollController.offset > ((MediaQuery.of(Get.context!).size.width * backgroundRatio)) - (kToolbarHeight * 2)) {
        if (isAppBarExpanded.value) {
          isAppBarExpanded(false);
        }
      } else {
        if (!isAppBarExpanded.value) {
          isAppBarExpanded(true);
        }
      }
    },);
    super.onInit();
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }



  Future<void> fetchEventDetail(int eventId) async {

    try{
      LoadingOverlay.show(null);

      await Future.delayed(const Duration(milliseconds: 300));

      event.value = TempEvent.dummy_data.map((data) => TempEvent.fromJson(data)).toList().firstWhereOrNull((element) => element.id == eventId,);
      eventFrameList.value = TempEventFrame.dummy_data.map((data) => TempEventFrame.fromJson(data)).where((element) => element.eventId == eventId,).toList();
      eventFilterList.value = TempEventFilter.dummy_data.map((data) => TempEventFilter.fromJson(data)).toList();

      Logger().d("event ${event}\n eventFrame ::: ${eventFrameList}\n eventFilter ::: ${eventFilterList}");

    }catch(e, stackTrace){
      Logger().e("error ::: $e");
      Logger().e("stackTrace ::: $stackTrace");
    }finally{
      LoadingOverlay.hide();
    }

  }

}