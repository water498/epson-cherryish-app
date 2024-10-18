
import 'package:seeya/data/repository/repositories.dart';

import '../model/models.dart';
import '../provider/providers.dart';

class MapTabRepository extends BaseApiRepository {
  final EventApi eventApi;

  MapTabRepository({required this.eventApi});

  Future<CommonResponseModel> fetchEventListApi([String? eventIds]) async {
    return handleApiResponse(eventApi.fetchEventListApi(eventIds));
  }

}