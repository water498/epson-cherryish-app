import 'package:get/get.dart';
import 'package:seeya/data/repository/report_repository.dart';

import '../controller/controllers.dart';
import '../data/provider/providers.dart';
import '../data/repository/repositories.dart';

class ReportBinding implements Bindings {

  @override
  void dependencies() {
    Get.lazyPut<ReportApi>(() => ReportApi());
    Get.lazyPut<PrinterApi>(() => PrinterApi());
    Get.lazyPut<ReportRepository>(() => ReportRepository(reportApi: Get.find(), printerApi: Get.find()),);
    Get.lazyPut<ReportController>(() => ReportController(reportRepository: Get.find()),);
  }

}