import 'package:json_annotation/json_annotation.dart';

part 'user_info.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class UserInfo {
  final int userId;
  final String email;
  final String? name;
  final String? profileUrl;
  final DateTime? phoneNumberVerificationDate;
  final String accessType;

  UserInfo({
    required this.userId,
    required this.email,
    this.name,
    this.profileUrl,
    this.phoneNumberVerificationDate,
    required this.accessType,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) =>
      _$UserInfoFromJson(json);

  Map<String, dynamic> toJson() => _$UserInfoToJson(this);
}
