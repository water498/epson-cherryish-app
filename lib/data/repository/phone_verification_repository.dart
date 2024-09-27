
import 'package:seeya/data/repository/repositories.dart';

import '../model/models.dart';
import '../provider/providers.dart';

class PhoneVerificationRepository extends BaseApiRepository {
  final AuthApi authApi;

  PhoneVerificationRepository({required this.authApi});

  Future<CommonResponseModel> phoneVerificationApi(request) async {
    return handleApiResponse(authApi.phoneVerificationApi(request));
  }

}