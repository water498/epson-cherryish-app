
import 'package:seeya/data/repository/repositories.dart';

import '../model/models.dart';
import '../provider/providers.dart';

class EventDetailRepository extends BaseApiRepository {
  final EventApi eventApi;

  EventDetailRepository({required this.eventApi});

  Future<CommonResponseModel> fetchEventDetailsApi(int eventId) async {
    return handleApiResponse(eventApi.fetchEventDetailsApi(eventId));
  }

}