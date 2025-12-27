import 'package:json_annotation/json_annotation.dart';
import '../../enum/enums.dart';

part 'user_detail.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class UserDetail {
  final int userId;
  final String? name;
  final UserStatus? status;
  final String email;
  final String? phoneNumber;
  final DateTime? phoneNumberVerificationDate;
  final String? profileUrl;
  final String? socialId;
  final SocialLoginType? socialType;
  final String? fcmToken;
  final String? osName;
  final String? osVersion;
  final DateTime? createdDate;
  final DateTime? updatedDate;
  final DateTime? deletedDate;
  final DateTime? lastLoginDate;

  UserDetail({
    required this.userId,
    this.name,
    this.status,
    required this.email,
    this.phoneNumber,
    this.phoneNumberVerificationDate,
    this.profileUrl,
    this.socialId,
    this.socialType,
    this.fcmToken,
    this.osName,
    this.osVersion,
    this.createdDate,
    this.updatedDate,
    this.deletedDate,
    this.lastLoginDate,
  });

  factory UserDetail.fromJson(Map<String, dynamic> json) =>
      _$UserDetailFromJson(json);

  Map<String, dynamic> toJson() => _$UserDetailToJson(this);
}
