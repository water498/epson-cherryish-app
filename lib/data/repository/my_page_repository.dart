import 'package:seeya/data/repository/repositories.dart';

import '../model/models.dart';
import '../provider/providers.dart';

class MyPageRepository extends BaseApiRepository {
  final AuthApi authApi;

  MyPageRepository({required this.authApi});

  Future<CommonResponseModel> validateTokenApi() async {
    return handleApiResponse(authApi.validateTokenApi());
  }

  Future<CommonResponseModel> fetchMyProfile() async {
    return handleApiResponse(authApi.fetchMyProfileApi());
  }

}