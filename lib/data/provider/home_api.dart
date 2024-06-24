import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'base_api.dart';

class HomeApi extends BaseApi {

  Future<Response> fetchTemplateListApi() async {
    return await get("/private/photo-template/all");
  }

}