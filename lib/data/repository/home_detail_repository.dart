
import 'package:seeya/data/repository/repositories.dart';

import '../model/models.dart';
import '../provider/providers.dart';

class HomeDetailRepository extends BaseApiRepository {
  final HomeDetailApi homeDetailApi;

  HomeDetailRepository({required this.homeDetailApi});

  Future<CommonResponseModel> fetchHomeDetailApi(String templateUid) async {
    return handleApiResponse(homeDetailApi.fetchHomeDetailApi(templateUid));
  }

}