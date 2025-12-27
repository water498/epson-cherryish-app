import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:seeya/core/config/app_router.dart';
import 'package:seeya/data/model/models.dart';
import 'package:seeya/view/common/loading_overlay.dart';

import '../core/data/model/event/event.dart';
import '../core/data/model/event/editor_frame.dart';
import '../core/data/repository/file_repository.dart';
import '../core/data/repository/print_repository.dart';
import '../core/data/model/print/print_models.dart';
import '../core/services/user_service.dart';
import '../view/dialog/dialogs.dart';

class DecorateFrameController extends GetxController{

  // v2 repositories
  final fileRepository = FileRepository();
  final printRepository = PrintRepository();




  // v2 models
  late Event event;
  late EditorFrame editorFrame;

  // v1 models (for backward compatibility with UI)
  late EventFrameModel eventFrame;
  late List<EventFilterModel> eventFilterList;
  var mergedPhotoList = <int,CameraResultModel?>{}.obs;


  @override
  void onInit() {

    // v2: Receive Event and EditorFrame
    event = Get.arguments["event"];
    editorFrame = Get.arguments["event_frame"];

    // Convert v2 EditorFrame to v1 EventFrameModel for UI compatibility
    eventFrame = EventFrameModel(
      uid: editorFrame.id.toString(),
      frame_type: editorFrame.type.value.toLowerCase(), // TYPE_A -> type_a
      name: editorFrame.name,
      background_color: '#000000', // Default, not used in v2
      index: 0,
      original_image_filepath: editorFrame.originalFrameImageFilepath ?? '',
      preview_image_filepath: editorFrame.resizedFrameImageFilepath ?? '',
      event_id: event.id,
      partner_id: 0, // Not available in v2
      createdDate: editorFrame.createdDate,
      updatedDate: editorFrame.updatedDate,
    );

    // Generate eventFilterList from EditorFrame filter paths
    eventFilterList = _generateFilterListFromEditorFrame(editorFrame, event.id);

    super.onInit();
  }

  /// Generate EventFilterModel list from EditorFrame filter image paths
  List<EventFilterModel> _generateFilterListFromEditorFrame(EditorFrame frame, int eventId) {
    final filters = <EventFilterModel>[];

    final filterMap = {
      'lt': frame.resizedFilterLtImageFilepath,
      'rt': frame.resizedFilterRtImageFilepath,
      'lb': frame.resizedFilterLbImageFilepath,
      'rb': frame.resizedFilterRbImageFilepath,
    };

    int index = 0;
    filterMap.forEach((type, filepath) {
      if (filepath != null && filepath.isNotEmpty) {
        filters.add(EventFilterModel(
          uid: '${frame.id}_$type',
          type: type,
          name: type.toUpperCase(),
          index: index++,
          image_filepath: filepath,
          event_editor_frame_uid: frame.id.toString(),
          event_id: eventId,
          partner_id: 0,
          created_date: frame.createdDate,
          updated_date: frame.updatedDate,
        ));
      }
    });

    return filters;
  }

  @override
  void onClose() {
    super.onClose();
  }



  Future<void> printFinalFrame(BuildContext context) async {

    bool allPhotosCaptured = mergedPhotoList.values.where((value) => value != null).length == eventFilterList.length;
    if(!allPhotosCaptured){
      Fluttertoast.showToast(msg: "decorate_frame.toast.empty_cut".tr);
      return;
    }

    if(eventFilterList.isEmpty) return;

    showDialog(context: context, builder: (context) {
      return CommonDialog(
        needWarning: true,
        title: "decorate_frame_confirm_dialog.title".tr,
        description: "decorate_frame_confirm_dialog.description".tr,
        button01text: "decorate_frame_confirm_dialog.button01".tr,
        onButton01Click: () async {

        },
        button02text: "decorate_frame_confirm_dialog.button02".tr,
        onButton02Click: () async {
          // v2: Upload images and create print queue directly
          await uploadAndCreatePrintQueue();
        },
      );
    },);


  }








  void showCompletedDialog(int waitCount) {
    if(Get.context == null) return;
    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (context) {
        return CommonDialog(
          title: "decorate_frame_complete_dialog.title".trParams({'waitCount':waitCount.toString()}),
          button01text: "decorate_frame_complete_dialog.button01".tr,
          onButton01Click: () async {
            Get.offNamed(AppRouter.print_history);
          },
          button02text: "decorate_frame_complete_dialog.button02".tr,
          onButton02Click: () async {
            Get.until((route) => Get.currentRoute == AppRouter.event_detail);
          },
        );
      },);
  }



  // ========== v2 API Methods ==========

  /// v2 API: Print flow that uploads 4 individual images and creates print queue
  Future<void> printFinalFrameV2(BuildContext context) async {
    // Validate all photos captured
    bool allPhotosCaptured = mergedPhotoList.values.where((value) => value != null).length == eventFilterList.length;
    if(!allPhotosCaptured){
      Fluttertoast.showToast(msg: "decorate_frame.toast.empty_cut".tr);
      return;
    }

    if(eventFilterList.isEmpty) return;

    showDialog(context: context, builder: (context) {
      return CommonDialog(
        needWarning: true,
        title: "decorate_frame_confirm_dialog.title".tr,
        description: "decorate_frame_confirm_dialog.description".tr,
        button01text: "decorate_frame_confirm_dialog.button01".tr,
        onButton01Click: () async {
          // Cancel
        },
        button02text: "decorate_frame_confirm_dialog.button02".tr,
        onButton02Click: () async {
          await uploadAndCreatePrintQueue();
        },
      );
    },);
  }

  /// v2 API: Upload 4 images individually and create print queue
  Future<void> uploadAndCreatePrintQueue() async {

    // Check phone verification
    if (UserService.instance.userDetail.value?.phoneNumberVerificationDate == null) {
      Get.toNamed(AppRouter.phone_verification);
      return;
    }

    try {
      LoadingOverlay.show();

      // Upload images individually - Map by filter type (lt, rt, lb, rb)
      Map<String, String> uploadedFilepaths = {};

      for(int i = 0; i < mergedPhotoList.length; i++) {
        var photo = mergedPhotoList[i];
        if(photo != null && photo.file != null) {
          LoadingOverlay.show("loading.image_upload_progress".trParams({'current': '${i + 1}', 'total': '${mergedPhotoList.length}'}));
          var response = await fileRepository.uploadImage(photo.file);

          // Map index to filter type based on eventFilterList
          if(i < eventFilterList.length) {
            String filterType = eventFilterList[i].type; // lt, rt, lb, rb
            uploadedFilepaths[filterType] = response.originalFilepath;
          }
        }
      }

      // Ensure all 4 filters have filepaths
      if(uploadedFilepaths.length != 4) {
        Fluttertoast.showToast(msg: "decorate_frame.toast.all_images_required".tr);
        return;
      }

      // Create print queue request
      var request = CreatePrintQueueRequest(
        eventId: event.id,
        editorFrameId: editorFrame.id,
        filterLtFilepath: uploadedFilepaths['lt']!,
        filterRtFilepath: uploadedFilepaths['rt']!,
        filterLbFilepath: uploadedFilepaths['lb']!,
        filterRbFilepath: uploadedFilepaths['rb']!,
      );

      LoadingOverlay.show("loading.creating_print_queue".tr);
      await printRepository.createPrintQueue(request);

      LoadingOverlay.show("loading.overlay05".tr, 1);
      await Future.delayed(const Duration(seconds: 3));

      // Show success dialog (reusing existing dialog, wait_count = 0 as placeholder)
      showCompletedDialog(0);

    } catch (e, stackTrace){
      Logger().e("error ::: $e");
      Logger().e("stackTrace ::: $stackTrace");

      // Handle specific errors
      if (e.toString().contains('409')) {
        Fluttertoast.showToast(msg: "decorate_frame.toast.already_printing".tr);
      } else if (e.toString().contains('422')) {
        Fluttertoast.showToast(msg: "toast.unknown_error".tr);
      } else {
        Fluttertoast.showToast(msg: "toast.unknown_error".tr);
      }
    } finally {
      LoadingOverlay.hide();
    }
  }

}