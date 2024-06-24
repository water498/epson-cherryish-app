import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'base_api.dart';

class HomeDetailApi extends BaseApi {

  Future<Response> fetchHomeDetailApi(String templateUid) async {
    return await get("/private/photo-template/${templateUid}");
  }

}