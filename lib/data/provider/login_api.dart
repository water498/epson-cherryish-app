import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'base_api.dart';

class LoginApi extends BaseApi {

  Future<Response> fetchLoginApi(Map<String, dynamic> request) async {
    return await post("/public/login/mobile", request);
  }

}