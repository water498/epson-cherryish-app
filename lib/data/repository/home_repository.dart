
import 'package:seeya/data/repository/repositories.dart';

import '../model/models.dart';
import '../provider/providers.dart';

class HomeRepository extends BaseApiRepository {
  final HomeApi homeApi;

  HomeRepository({required this.homeApi});

  Future<CommonResponseModel> fetchHomeFrameListApi() async {
    return handleApiResponse(homeApi.fetchHomeFrameListApi());
  }

}