import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:seeya/core/data/model/event/event.dart';
import 'package:seeya/core/data/model/event/editor_frame.dart';
import 'package:seeya/core/data/model/event/event_detail_response.dart';
import 'package:seeya/core/data/repository/event_repository.dart';

// v1 (deprecated)
// import 'package:seeya/data/repository/repositories.dart';
// import '../data/model/models.dart';
import '../view/common/loading_overlay.dart';

class EventDetailController extends GetxController{

  final eventRepository = EventRepository();







  double backgroundRatio = 0.9;

  int eventId = -1;
  late final ScrollController scrollController;
  var isAppBarExpanded = true.obs;

  Rxn<Event> event = Rxn<Event>();
  RxList<EditorFrame> eventFrameList = <EditorFrame>[].obs;


  @override
  void onInit() {

    if (Get.arguments is int) {
      eventId = Get.arguments as int;
    }

    if (eventId == -1){
      Fluttertoast.showToast(msg: "event_detail.toast.load_fail".tr);
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

      // v2 API
      EventDetailResponse response = await eventRepository.getEventDetail(eventId);

      event.value = response.event;
      eventFrameList.value = response.editorFrames;

    }catch(e, stackTrace){
      Logger().e("error ::: $e");
      Logger().e("stackTrace ::: $stackTrace");
    }finally{
      LoadingOverlay.hide();
    }

  }

}