import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:seeya/core/config/app_router.dart';
import 'package:seeya/core/data/model/print/print_models.dart';
import 'package:seeya/core/data/repository/print_repository.dart';
import 'package:seeya/view/common/loading_overlay.dart';
import 'package:seeya/view/dialog/common_dialog.dart';

class PrintHistoryController extends GetxController{

  final printRepository = PrintRepository();

  RxList<PrintQueue> historyList = <PrintQueue>[].obs;
  var isLoadFinish = false.obs;

  static const int limit = 100; // 한 번에 가져올 항목 수


  @override
  void onInit() {
    super.onInit();
    fetchHistory();
  }

  Future<void> fetchHistory() async {
    try {
      // v2 API: Get print queue items
      List<PrintQueue> items = await printRepository.getPrintQueues(
        skip: 0,
        limit: limit,
      );

      historyList.value = items;

    } catch (e, stackTrace){
      Logger().e("error ::: $e");
      Logger().e("stackTrace ::: $stackTrace");
      Fluttertoast.showToast(msg: "toast.unknown_error".tr);
    } finally {
      isLoadFinish(true);
    }
  }

  /// 재출력 버튼 클릭 시 호출
  Future<void> reprintItem(int index) async {
    if(Get.context == null) return;

    final item = historyList[index];

    showDialog(
      context: Get.context!,
      builder: (context) => CommonDialog(
        title: "report_reprint_dialog.title".tr,
        button01text: "report_reprint_dialog.button01".tr,
        onButton01Click: () async {
          // Cancel - dialog closes automatically
        },
        button02text: "report_reprint_dialog.button02".tr,
        onButton02Click: () async {
          await _executeReprint(item.id);
        },
      ),
    );
  }

  /// 재출력 API 호출 실행
  Future<void> _executeReprint(int queueId) async {
    try {
      LoadingOverlay.show();

      // API 호출
      final newPrintQueue = await printRepository.reprintQueue(queueId);

      // 성공 메시지 표시 (3초)
      LoadingOverlay.show("loading.overlay05".tr, 1);
      await Future.delayed(const Duration(seconds: 3));

      // 완료 다이얼로그 표시
      showCompletedDialog(newPrintQueue.id);

      // 히스토리 목록 새로고침
      await fetchHistory();

    } catch (e, stackTrace){
      Logger().e("error ::: $e");
      Logger().e("stackTrace ::: $stackTrace");
      // Interceptor에서 에러 toast를 처리하므로 여기서는 로깅만 수행
    } finally {
      LoadingOverlay.hide();
    }
  }

  /// 재출력 완료 다이얼로그 표시
  void showCompletedDialog(int queueId) {
    if(Get.context == null) return;

    showDialog(
      context: Get.context!,
      barrierDismissible: false,
      builder: (context) {
        return CommonDialog(
          title: "print_history_reprint_complete_dialog.title".trParams({'queueId': queueId.toString()}),
          button02text: "print_history_reprint_complete_dialog.button01".tr,
          onButton02Click: () async {
            // Go to root (which contains MyPage tab)
            Get.until((route) => Get.currentRoute == AppRouter.root);
          },
        );
      },
    );
  }

}