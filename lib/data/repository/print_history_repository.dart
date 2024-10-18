
import 'package:seeya/data/repository/repositories.dart';

import '../model/models.dart';
import '../provider/providers.dart';

class PrintHistoryRepository extends BaseApiRepository {
  final PrinterApi printerApi;

  PrintHistoryRepository({required this.printerApi});

  Future<CommonResponseModel> fetchPrintHistories() async {
    return handleApiResponse(printerApi.fetchPrintHistories());
  }

}