import 'dart:convert';

import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../model/models.dart';

class BaseApiRepository extends GetxService {

  Future<CommonResponseModel> handleApiResponse(Future<Response> apiCall) async {
    try {
      Response res = await apiCall;

      Logger().d('BaseRepository response \nstatus :::: ${res.statusCode}\n\nbody ::::   ${jsonEncode(res.body)}');

      if (res.statusCode != null && res.statusCode! >= 200 && res.statusCode! < 300) {
        return CommonResponseModel(
          successModel: CommonSuccessModel.fromJson(res.body),
          statusCode: res.statusCode
        );
      } else {
        return CommonResponseModel(
          failModel: CommonFailModel.fromJson(res.body),
          statusCode: res.statusCode
        );
      }
    } catch (e) {
      Logger().d("ERROR: $e");
      rethrow;
    }
  }

}
