
import 'package:seeya/data/repository/repositories.dart';

import '../model/models.dart';
import '../provider/providers.dart';

class WithdrawalRepository extends BaseApiRepository {
  final AuthApi authApi;

  WithdrawalRepository({required this.authApi});

  Future<CommonResponseModel> withdrawalApi() async {
    return handleApiResponse(authApi.withdrawalApi());
  }

}