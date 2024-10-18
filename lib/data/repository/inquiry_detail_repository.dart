
import 'package:seeya/data/repository/repositories.dart';

import '../model/models.dart';
import '../provider/providers.dart';

class InquiryDetailRepository extends BaseApiRepository {
  final ReportApi reportApi;

  InquiryDetailRepository({required this.reportApi});

  Future<CommonResponseModel> fetchReportApi(int reportId) async {
    return handleApiResponse(reportApi.fetchReportApi(reportId));
  }

}