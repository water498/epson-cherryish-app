import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'base_api.dart';

class PhotoListApi extends BaseApi {


  Future<Response> tempApi(Map<String, dynamic> request) async {
    return await post("/private/printer/request", request);
  }

}