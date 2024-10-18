import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'base_api.dart';

class HomeApi extends BaseApi {

  Future<Response> fetchHomeFrameListApi() async {
    return await get("/public/home/best/frame/list");
  }

}