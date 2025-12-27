import 'package:json_annotation/json_annotation.dart';

@JsonEnum(valueField: 'value')
enum UserStatus {
  active('ACTIVE'),
  blocked('BLOCKED');

  final String value;
  const UserStatus(this.value);

  static UserStatus fromValue(String value) {
    return UserStatus.values.firstWhere((e) => e.value == value);
  }
}
