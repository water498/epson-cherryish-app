import 'package:get/get.dart';

import '../controller/controllers.dart';
import '../data/provider/providers.dart';
import '../data/repository/repositories.dart';

class EventDetailBinding implements Bindings {

  @override
  void dependencies() {
    Get.lazyPut<EventApi>(() => EventApi());
    Get.lazyPut<EventDetailRepository>(() => EventDetailRepository(eventApi: Get.find()),);
    Get.lazyPut<EventDetailController>(() => EventDetailController(eventDetailRepository: Get.find()),);
  }

}