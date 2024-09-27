import 'models.dart';

class ValidateTokenResponseModel {
  UserInfoModel user;
  bool success;

  ValidateTokenResponseModel({
    required this.user,
    required this.success,
  });

  factory ValidateTokenResponseModel.fromJson(Map<String, dynamic> json) {
    return ValidateTokenResponseModel(
      user: UserInfoModel.fromJson(json['user']),
      success : json['success'],
    );
  }
}