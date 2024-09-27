
import 'package:seeya/data/repository/repositories.dart';

import '../model/models.dart';
import '../provider/providers.dart';

class RootRepository extends BaseApiRepository {
  final HomeApi homeApi;

  RootRepository({required this.homeApi});

  Future<CommonResponseModel> fetchPhotoListApi() async {
    return handleApiResponse(homeApi.fetchTemplateListApi());
  }

}