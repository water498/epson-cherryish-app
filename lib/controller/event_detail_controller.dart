import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:seeya/data/repository/repositories.dart';

import '../data/model/models.dart';
import '../view/common/loading_overlay.dart';

class EventDetailController extends GetxController{

  final EventDetailRepository eventDetailRepository;

  EventDetailController({required this.eventDetailRepository});







  double backgroundRatio = 0.9;

  int eventId = -1;
  late final ScrollController scrollController;
  var isAppBarExpanded = true.obs;

  Rxn<EventModel> event = Rxn<EventModel>();
  RxList<EventFrameModel> eventFrameList = <EventFrameModel>[].obs;
  RxList<EventFilterModel> eventFilterList = <EventFilterModel>[].obs;


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
      LoadingOverlay.show();

      await Future.delayed(const Duration(milliseconds: 300));

      CommonResponseModel commonResponse = await eventDetailRepository.fetchEventDetailsApi(eventId);

      if(commonResponse.successModel != null){

        event.value = EventModel.fromJson(commonResponse.successModel!.content["event"]);
        eventFrameList.value = EventFrameModel.fromJsonList(commonResponse.successModel!.content["event_editor_frames"]);
        eventFilterList.value = EventFilterModel.fromJsonList(commonResponse.successModel!.content["event_editor_filters"]);

      } else if(commonResponse.failModel != null) {

      }

    }catch(e, stackTrace){
      Logger().e("error ::: $e");
      Logger().e("stackTrace ::: $stackTrace");
    }finally{
      LoadingOverlay.hide();
    }

  }

}