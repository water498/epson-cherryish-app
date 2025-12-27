import 'package:json_annotation/json_annotation.dart';
import '../../enum/enums.dart';

part 'login_request.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class LoginRequest {
  final String email;
  final String socialId;
  final SocialLoginType socialType;
  final String? name;
  final String? phoneNumber;
  final String? profileUrl;
  final String? fcmToken;
  final String? osName;
  final String? osVersion;

  LoginRequest({
    required this.email,
    required this.socialId,
    required this.socialType,
    this.name,
    this.phoneNumber,
    this.profileUrl,
    this.fcmToken,
    this.osName,
    this.osVersion,
  });

  factory LoginRequest.fromJson(Map<String, dynamic> json) =>
      _$LoginRequestFromJson(json);

  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}
