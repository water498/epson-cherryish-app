
import 'dart:io';

import 'package:seeya/data/repository/repositories.dart';

import '../model/models.dart';
import '../provider/providers.dart';

class ReportRepository extends BaseApiRepository {
  final ReportApi reportApi;
  final PrinterApi printerApi;

  ReportRepository({required this.reportApi, required this.printerApi});

  Future<CommonResponseModel> fetchReportsApi() async {
    return handleApiResponse(reportApi.fetchReportsApi());
  }

  Future<CommonResponseModel> fetchPrintHistories() async {
    return handleApiResponse(printerApi.fetchPrintHistories());
  }






  Future<CommonResponseModel> checkPrinterAccess(int eventId, [String? s3_filepath]) async {
    return handleApiResponse(printerApi.checkPrinterAccess(eventId, s3_filepath));
  }

  Future<CommonResponseModel> requestPrintApi(Map<String, dynamic> request) async {
    return handleApiResponse(printerApi.requestPrintApi(request));
  }





}