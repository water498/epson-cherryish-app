import 'dart:io';

class LoginRequestModel{

  String? name;
  String? email;
  String? profile_url;
  String social_type;
  String social_id;
  String? fcm_token;
  String? os_name;
  String? os_version;

  LoginRequestModel({
    this.name,
    this.email,
    this.profile_url,
    required this.social_type,
    required this.social_id,
    this.fcm_token,
    this.os_name,
    this.os_version,
  }){
    os_name = Platform.isIOS ? "ios" : "aos";
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      'name': name,
      'email': email,
      'profile_url': profile_url,
      'social_type': social_type,
      'social_id': social_id,
      'fcm_token': fcm_token,
      'os_name': os_name,
      'os_version': os_version,
    };

    json.removeWhere((key, value) => value == null || value == '');

    return json;
  }


}

class LoginResponseModel {
  UserPublicModel user;
  bool need_phone_verification;
  String access_token;

  LoginResponseModel({
    required this.user,
    required this.need_phone_verification,
    required this.access_token
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      user: UserPublicModel.fromJson(json['item']),
      need_phone_verification : json['need_phone_verification'],
      access_token: json['access_token'],
    );
  }

}




// public
class UserPublicModel {
  int id;
  String? name;
  String email;
  String? profile_url;
  String? fcm_token;
  String? os_name;
  String? os_version;
  DateTime created_date;
  DateTime last_login_date;
  DateTime? deleted_date;
  String social_type;



  UserPublicModel({
    required this.id,
    this.name,
    required this.email,
    this.profile_url,
    this.fcm_token,
    this.os_name,
    this.os_version,
    required this.created_date,
    required this.last_login_date,
    this.deleted_date,
    required this.social_type,
  });

  factory UserPublicModel.fromJson(Map<String, dynamic> json) {
    return UserPublicModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      profile_url: json['profile_url'],
      fcm_token: json['fcm_token'],
      os_name: json['os_name'],
      os_version: json['os_version'],
      created_date: DateTime.parse(json['created_date']),
      last_login_date: DateTime.parse(json['last_login_date']),
      deleted_date: json['deleted_date'] != null ? DateTime.parse(json['deleted_date']) : null,
      social_type: json['social_type'],
    );
  }


}





class UserPrivateModel {
  UserPublicModel userPublicModel;
  String phone_number;
  DateTime phone_number_verification_date;
  String social_id;


  UserPrivateModel({
    required this.userPublicModel,
    required this.phone_number,
    required this.phone_number_verification_date,
    required this.social_id,
  });

  factory UserPrivateModel.fromJson(Map<String, dynamic> json) {
    return UserPrivateModel(
      userPublicModel: UserPublicModel.fromJson(json),
      phone_number: json['phone_number'],
      phone_number_verification_date: DateTime.parse(json['phone_number_verification_date']),
      social_id: json['social_id'],
    );
  }


}


