import 'dart:io';

import 'package:get/get.dart';
import 'base_api.dart';
import 'package:path/path.dart';

class PrinterApi extends BaseApi {

  Future<Response> checkPrinterAccess(int eventId, String? s3_filepath) async {
    return await post("/mobile/print/$eventId/check/access",
        {
          "s3_filepath" : s3_filepath
        }
    );
  }

  Future<Response> uploadFinalImage(int eventId, File image) async {
    final form = FormData({
      'file': MultipartFile(image, filename: basename(image.path)),
    });

    return await post("/mobile/print/$eventId/file/upload", form);
  }

  Future<Response> requestPrintApi(Map<String, dynamic> request) async {
    return await post("/mobile/print/request", request);
  }


  Future<Response> fetchPrintHistories () async {
    return await get("/mobile/print/history/list");
  }

}