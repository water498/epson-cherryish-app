import 'package:get/get.dart';

import '../controller/controllers.dart';
import '../data/provider/providers.dart';
import '../data/repository/repositories.dart';

class QnaBinding implements Bindings {

  @override
  void dependencies() {
    Get.lazyPut<QnaApi>(() => QnaApi());
    Get.lazyPut<QnaRepository>(() => QnaRepository(qnaApi: Get.find()),);
    Get.lazyPut<QnaController>(() => QnaController(qnaRepository: Get.find()),);
  }

}