import 'package:seeya/core/data/enum/enums.dart';

enum LoginPlatform{
  apple,
  google,
  kakao,
  naver,
  none,
}

class LoginPlatformUtils {
  static LoginPlatform stringToEnum(String? socialType) {
    switch (socialType) {
      case 'apple':
        return LoginPlatform.apple;
      case 'google':
        return LoginPlatform.google;
      case 'kakao':
        return LoginPlatform.kakao;
      case 'naver':
        return LoginPlatform.naver;
      default :
        return LoginPlatform.none;
    }
  }
}

extension LoginPlatformExtension on LoginPlatform {
  String toDisplayString() {
    switch (this) {
      case LoginPlatform.apple:
        return 'apple';
      case LoginPlatform.google:
        return 'google';
      case LoginPlatform.kakao:
        return 'kakao';
      case LoginPlatform.naver:
        return 'naver';
      case LoginPlatform.none:
        return 'none';
    }
  }

  /// LoginPlatform → SocialLoginType 변환 (API 요청용)
  SocialLoginType toSocialLoginType() {
    switch (this) {
      case LoginPlatform.apple:
        return SocialLoginType.apple;
      case LoginPlatform.google:
        return SocialLoginType.google;
      case LoginPlatform.kakao:
        return SocialLoginType.kakao;
      case LoginPlatform.naver:
        return SocialLoginType.naver;
      case LoginPlatform.none:
        throw ArgumentError('LoginPlatform.none cannot be converted to SocialLoginType');
    }
  }

}