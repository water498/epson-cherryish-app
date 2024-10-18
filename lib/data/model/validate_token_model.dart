import 'models.dart';

class ValidateTokenResponseModel {
  UserPublicModel user;
  bool success;

  ValidateTokenResponseModel({
    required this.user,
    required this.success,
  });

  factory ValidateTokenResponseModel.fromJson(Map<String, dynamic> json) {
    return ValidateTokenResponseModel(
      user: UserPublicModel.fromJson(json['user']),
      success : json['success'],
    );
  }
}