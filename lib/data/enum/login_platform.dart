enum LoginPlatform{
  apple,
  google,
  kakao,
  naver,
  none,
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