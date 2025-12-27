import 'package:json_annotation/json_annotation.dart';
import 'package:seeya/core/data/model/auth/auth_models.dart';

part 'login_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class LoginResponse {
  final String accessToken;
  final String tokenType;
  final UserDetail userDetail;

  LoginResponse({
    required this.accessToken,
    required this.tokenType,
    required this.userDetail,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}
