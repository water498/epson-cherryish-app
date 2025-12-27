import 'package:get/get.dart';

import '../controller/controllers.dart';
// v1 (deprecated) - ErrorReportController now creates repositories directly
// import 'package:seeya/data/repository/report_repository.dart';
// import '../data/provider/providers.dart';
// import '../data/repository/repositories.dart';

class ErrorReportBinding implements Bindings {

  @override
  void dependencies() {
    // v2
    Get.lazyPut<ErrorReportController>(() => ErrorReportController());
  }

}