
import 'dart:io';

import 'package:seeya/data/repository/repositories.dart';

import '../model/models.dart';
import '../provider/providers.dart';

class DecorateFrameRepository extends BaseApiRepository {
  final PrinterApi printerApi;

  DecorateFrameRepository({required this.printerApi});

  Future<CommonResponseModel> checkPrinterAccess(int eventId, [String? s3_filepath]) async {
    return handleApiResponse(printerApi.checkPrinterAccess(eventId, s3_filepath));
  }

  Future<CommonResponseModel> uploadFinalImage(int eventId, File image) async {
    return handleApiResponse(printerApi.uploadFinalImage(eventId, image));
  }

  Future<CommonResponseModel> requestPrintApi(Map<String, dynamic> request) async {
    return handleApiResponse(printerApi.requestPrintApi(request));
  }


}