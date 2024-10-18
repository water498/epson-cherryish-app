import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'base_api.dart';

class AuthApi extends BaseApi {

  Future<Response> callLoginApi(Map<String, dynamic> request) async {
    return await put("/public/auth/mobile/login", request);
  }

  Future<Response> validateTokenApi() async {
    return await post("/mobile/auth/validate/token", null);
  }

  Future<Response> fetchMyProfileApi() async {
    return await get("/mobile/auth/profile");
  }

  Future<Response> phoneVerificationApi(Map<String, dynamic> request) async {
    return await put("/mobile/auth/phone/verification", request);
  }

  Future<Response> withdrawalApi() async {
    return await delete("/mobile/auth/signout");
  }

}