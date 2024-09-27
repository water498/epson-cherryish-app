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

}