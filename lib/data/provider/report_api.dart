import 'dart:io';

import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart';
import 'base_api.dart';

class ReportApi extends BaseApi {

  Future<Response> fetchReportApi(int reportId) async {
    return await get("/mobile/report/$reportId");
  }

  Future<Response> fetchReportsApi() async {
    return await get("/mobile/report/list");
  }

  Future<Response> requestReport(Map<String, dynamic> request) async {
    return await post("/mobile/report", request);
  }

  Future<Response> uploadReportImage(int eventId, File image) async {
    final form = FormData({
      'file': MultipartFile(image, filename: basename(image.path)),
    });

    return await post("/mobile/report/file/upload/$eventId", form);
  }

}