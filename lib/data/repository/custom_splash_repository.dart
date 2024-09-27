import 'package:seeya/data/repository/repositories.dart';

import '../model/models.dart';
import '../provider/providers.dart';

class CustomSplashRepository extends BaseApiRepository {
  final AuthApi authApi;

  CustomSplashRepository({required this.authApi});

  Future<CommonResponseModel> validateTokenApi() async {
    return handleApiResponse(authApi.validateTokenApi());
  }

}