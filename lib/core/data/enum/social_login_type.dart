import 'package:json_annotation/json_annotation.dart';

@JsonEnum(valueField: 'value')
enum SocialLoginType {
  google('GOOGLE'),
  apple('APPLE'),
  kakao('KAKAO'),
  naver('NAVER');

  final String value;
  const SocialLoginType(this.value);

  static SocialLoginType fromValue(String value) {
    return SocialLoginType.values.firstWhere((e) => e.value == value);
  }
}
