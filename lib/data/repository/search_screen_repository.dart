
import 'package:seeya/data/repository/repositories.dart';

import '../model/models.dart';
import '../provider/providers.dart';

class SearchScreenRepository extends BaseApiRepository {
  final SearchApi searchApi;

  SearchScreenRepository({required this.searchApi});

  Future<CommonResponseModel> searchEventsFromKeywordApi(String keyword) async {
    return handleApiResponse(searchApi.searchEventsFromKeywordApi(keyword));
  }

}