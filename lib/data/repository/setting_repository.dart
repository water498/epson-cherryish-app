
import 'package:seeya/data/repository/repositories.dart';

import '../model/models.dart';
import '../provider/providers.dart';

class SettingRepository extends BaseApiRepository {
  final AuthApi authApi;

  SettingRepository({required this.authApi});

  Future<CommonResponseModel> fetchMyProfile() async {
    return handleApiResponse(authApi.fetchMyProfileApi());
  }

}