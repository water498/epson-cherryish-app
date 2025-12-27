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

  /// Parse from string (case-insensitive)
  /// Supports both uppercase ('GOOGLE') and lowercase ('google') formats
  static SocialLoginType? fromString(String? value) {
    if (value == null || value.isEmpty) return null;

    final upperValue = value.toUpperCase();
    try {
      return SocialLoginType.values.firstWhere((e) => e.value == upperValue);
    } catch (e) {
      return null;
    }
  }

  /// Returns lowercase string for display/storage (e.g., 'google', 'apple')
  String toDisplayString() {
    return value.toLowerCase();
  }
}
