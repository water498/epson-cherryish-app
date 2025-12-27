import 'package:json_annotation/json_annotation.dart';
import '../../enum/enums.dart';

part 'user_detail.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class UserDetail {
  final int userId;
  final String email;
  final String? name;
  final String? phoneNumber;
  final DateTime? phoneNumberVerificationDate;
  final String? profileUrl;
  final SocialLoginType? socialType;
  final UserStatus? status;
  final DateTime? lastLoginDate;

  UserDetail({
    required this.userId,
    required this.email,
    this.name,
    this.phoneNumber,
    this.phoneNumberVerificationDate,
    this.profileUrl,
    this.socialType,
    this.status,
    this.lastLoginDate,
  });

  factory UserDetail.fromJson(Map<String, dynamic> json) =>
      _$UserDetailFromJson(json);

  Map<String, dynamic> toJson() => _$UserDetailToJson(this);
}
