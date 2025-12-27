import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:seeya/core/config/app_secret.dart';

import '../../core/config/app_prefs_keys.dart';
import '../../core/services/preference_service.dart';
import '../../core/services/services.dart';

class BaseApi extends GetConnect {

  @override
  void onInit() {
    httpClient
      ..baseUrl = AppSecret.baseUrl
    // ..defaultDecoder = CommonResponseModel().fromJson; // 모든 요청은 jsonEncode로 CommonResponseModel.fromJson()를 거칩니다.
      ..defaultContentType = 'application/json'
      ..timeout = const Duration(seconds: 10)
      ..addRequestModifier<dynamic>((request) {
        request.headers['api-key'] = AppSecret.apiKey;
        final token = AppPreferences().prefs?.getString(AppPrefsKeys.userAccessToken);
        if(token != null){
          request.headers['authorization'] = 'Bearer $token';
        }
        return request;
      });
    super.onInit();
  }

}