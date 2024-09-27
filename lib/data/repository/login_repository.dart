
import 'package:seeya/data/repository/repositories.dart';

import '../model/models.dart';
import '../provider/providers.dart';

class LoginRepository extends BaseApiRepository {
  final AuthApi authApi;

  LoginRepository({required this.authApi});

  Future<CommonResponseModel> callLoginApi(request) async {
    return handleApiResponse(authApi.callLoginApi(request));
  }

}