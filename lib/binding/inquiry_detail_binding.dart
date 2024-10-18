import 'package:get/get.dart';

import '../controller/controllers.dart';
import '../data/provider/providers.dart';
import '../data/repository/repositories.dart';

class InquiryDetailBinding implements Bindings {

  @override
  void dependencies() {
    Get.lazyPut<ReportApi>(() => ReportApi());
    Get.lazyPut<InquiryDetailRepository>(() => InquiryDetailRepository(reportApi: Get.find()),);
    Get.lazyPut<InquiryDetailController>(() => InquiryDetailController(inquiryDetailRepository: Get.find()),);
  }

}