
import 'package:seeya/data/repository/repositories.dart';

import '../model/models.dart';
import '../provider/providers.dart';

class PurchaseRepository extends BaseApiRepository {
  final PrinterApi printerApi;

  PurchaseRepository({required this.printerApi});

  Future<CommonResponseModel> requestPrintApi(Map<String, dynamic> request) async {
    return handleApiResponse(printerApi.requestPrintApi(request));
  }

}