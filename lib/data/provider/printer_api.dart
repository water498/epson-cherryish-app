import 'dart:io';
import 'package:dio/dio.dart' hide Response;
import 'package:get/get_connect/http/src/response/response.dart' as GetResponse;
import 'package:get/get.dart' hide MultipartFile, FormData;
import 'package:path/path.dart';

import '../../core/config/app_prefs_keys.dart';
import '../../core/services/preference_service.dart';
import '../../core/services/services.dart';
import 'base_api.dart';

class PrinterApi extends BaseApi {
  Future<Response> checkPrinterAccess(int eventId, String? s3_filepath) async {
    return await post("/mobile/print/$eventId/check/free/access", {
      "s3_filepath": s3_filepath
    });
  }

  Future<GetResponse.Response> uploadFinalImage(int eventId, File image) async {
    final token = AppPreferences().prefs?.getString(AppPrefsKeys.userAccessToken);

    final dio = Dio(BaseOptions(
      baseUrl: 'https://api.seeya-printer.com',
      headers: {
        'Authorization': 'Bearer $token', // 혹시 토큰 필요하면
      },
      connectTimeout: const Duration(seconds: 40),
      sendTimeout: const Duration(seconds: 40), // ⬅️ 중요!
      receiveTimeout: const Duration(seconds: 40),
    ));

    final length = await image.length();

    final formData = FormData.fromMap({
      'file': MultipartFile.fromStream(
        ()=>image.openRead(),
        length,
        filename: basename(image.path),
      ),
    });

    final dioResponse = await dio.post(
      "/mobile/print/$eventId/file/upload",
      data: formData,
    );

    return GetResponse.Response(
      body: dioResponse.data,
      statusCode: dioResponse.statusCode,
      statusText: dioResponse.statusMessage,
      request: null,
    );
  }

  Future<Response> requestPrintApi(Map<String, dynamic> request) async {
    return await post("/mobile/print/request", request);
  }

  Future<Response> fetchPrintHistories() async {
    return await get("/mobile/print/history/list");
  }
}