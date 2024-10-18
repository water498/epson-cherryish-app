
import 'dart:io';

import 'package:seeya/data/repository/repositories.dart';

import '../model/models.dart';
import '../provider/providers.dart';

class ErrorReportRepository extends BaseApiRepository {
  final ReportApi reportApi;

  ErrorReportRepository({required this.reportApi});

  Future<CommonResponseModel> requestReport(Map<String, dynamic> request) async {
    return handleApiResponse(reportApi.requestReport(request));
  }

  Future<CommonResponseModel> uploadReportImage(int eventId, File image) async {
    return handleApiResponse(reportApi.uploadReportImage(eventId, image));
  }

}