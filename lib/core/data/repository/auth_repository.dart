import 'package:dio/dio.dart';
import 'package:seeya/core/config/app_prefs_keys.dart';
import 'package:seeya/core/data/model/auth/auth_models.dart';
import 'package:seeya/core/services/dio_service.dart';
import 'package:seeya/core/services/services.dart';

import '../../services/preference_service.dart';

class AuthRepository {
  final Dio _dio = DioService.to.dio;

  /// POST /api/v1/mobile/auth/login
  /// 소셜 로그인
  Future<LoginResponse> login(LoginRequest request) async {
    final response = await _dio.post(
      '/api/v1/mobile/auth/login',
      data: request.toJson(),
    );
    return LoginResponse.fromJson(response.data);
  }

  /// GET /api/v1/mobile/auth/me
  /// 현재 사용자 정보 조회
  Future<UserDetail> getMe() async {
    final response = await _dio.get('/api/v1/mobile/auth/me');
    return UserDetail.fromJson(response.data);
  }

  /// POST /api/v1/mobile/auth/phone/verify
  /// 폰번호 인증 결과
  Future<UserDetail> verifyPhone(PhoneVerifyRequest request) async {
    final response = await _dio.post(
      '/api/v1/mobile/auth/phone/verify',
      data: request.toJson(),
    );
    return UserDetail.fromJson(response.data);
  }

  /// POST /api/v1/mobile/auth/withdraw
  /// 회원탈퇴
  Future<Map<String, dynamic>> withdraw() async {
    final response = await _dio.post('/api/v1/mobile/auth/withdraw');
    return response.data;
  }

  /// 로그아웃 (로컬 토큰만 삭제, API 호출 없음)
  Future<void> logout() async {
    await AppPreferences().prefs?.remove(AppPrefsKeys.userAccessToken);
    // UserService 초기화는 controller에서 처리
  }
}
