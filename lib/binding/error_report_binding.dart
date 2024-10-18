import 'package:get/get.dart';
import 'package:seeya/data/repository/report_repository.dart';

import '../controller/controllers.dart';
import '../data/provider/providers.dart';
import '../data/repository/repositories.dart';

class ErrorReportBinding implements Bindings {

  @override
  void dependencies() {
    Get.lazyPut<ReportApi>(() => ReportApi());
    Get.lazyPut<ErrorReportRepository>(() => ErrorReportRepository(reportApi: Get.find()));
    // Get.put(ErrorReportController(errorReportRepository: Get.find()));
    Get.lazyPut<ErrorReportController>(() => ErrorReportController(errorReportRepository: Get.find()),);
  }

}