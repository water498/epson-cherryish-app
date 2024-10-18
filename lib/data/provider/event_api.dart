import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'base_api.dart';

class EventApi extends BaseApi {

  Future<Response> fetchEventListApi(String? eventIds) async {
    return await get("/public/event/list${eventIds != null ? "?event_ids=$eventIds" : ""}");
  }

  Future<Response> fetchEventDetailsApi(int eventId) async {
    return await get("/public/event/$eventId/detail");
  }

  Future<Response> fetchEventApi(int eventId) async {
    return await get("/public/event/$eventId");
  }

}