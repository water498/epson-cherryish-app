enum APIFailEnum{
  bad_access, // 정상적이지 못한 루트
  token_expired, // access token 만료
  token_empty, // access token 없음
  empty, // 요청한 템플릿을 찾지 못한 경우
  unknown, // 현재 처리할 수 없는 요청, 요청한 카테고리를 찾지 못한 경우
}

extension LoginApiExtension on APIFailEnum {
  String toDisplayString() {
    switch (this) {
      case APIFailEnum.bad_access:
        return 'BAD_ACCESS';
      case APIFailEnum.token_expired:
        return 'TOKEN_EXPIRED';
      case APIFailEnum.token_empty:
        return 'TOKEN_EMPTY';
      case APIFailEnum.empty:
        return 'EMPTY';
      case APIFailEnum.unknown:
        return 'UNKNOWN';
    }
  }
}