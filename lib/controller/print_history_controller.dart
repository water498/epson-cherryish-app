import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:seeya/core/data/model/print/print_models.dart';
import 'package:seeya/core/data/repository/print_repository.dart';

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

}