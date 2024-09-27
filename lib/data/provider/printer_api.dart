import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'base_api.dart';

class PrinterApi extends BaseApi {

  Future<Response> requestPrintApi(Map<String, dynamic> request) async {
    return await post("/private/printer", request);
  }

}