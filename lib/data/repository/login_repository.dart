
import 'package:seeya/data/repository/repositories.dart';

import '../model/models.dart';
import '../provider/providers.dart';

class LoginRepository extends BaseApiRepository {
  final LoginApi loginApi;

  LoginRepository({required this.loginApi});

  Future<CommonResponseModel> fetchLoginApi(request) async {
    return handleApiResponse(loginApi.fetchLoginApi(request));
  }

}