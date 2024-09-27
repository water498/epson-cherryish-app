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
  UserInfoModel user;
  bool need_phone_verification;
  String access_token;

  LoginResponseModel({
    required this.user,
    required this.need_phone_verification,
    required this.access_token
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      user: UserInfoModel.fromJson(json['item']),
      need_phone_verification : json['need_phone_verification'],
      access_token: json['access_token'],
    );
  }

}




// public
class UserInfoModel {
  int id;
  String? name;
  String? email;
  String? profile_url;
  String? fcm_token;
  String? os_name;
  String? os_version;
  String created_date;
  String last_login_date;
  String? deleted_date;
  String? social_type;



  UserInfoModel({
    required this.id,
    this.name,
    this.email,
    this.profile_url,
    this.fcm_token,
    this.os_name,
    this.os_version,
    required this.created_date,
    required this.last_login_date,
    this.deleted_date,
    this.social_type,
  });

  factory UserInfoModel.fromJson(Map<String, dynamic> json) {
    return UserInfoModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      profile_url: json['profile_url'],
      fcm_token: json['fcm_token'],
      os_name: json['os_name'],
      os_version: json['os_version'],
      created_date: json['created_date'],
      last_login_date: json['last_login_date'],
      deleted_date: json['deleted_date'],
      social_type: json['social_type'],
    );
  }


  UserInfoModel copyWith({
    int? id,
    String? name,
    String? email,
    String? profile_url,
    String? fcm_token,
    String? os_name,
    String? os_version,
    String? created_date,
    String? last_login_date,
    String? deleted_date,
    String? social_type,
  }) {
    return UserInfoModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      profile_url: profile_url ?? this.profile_url,
      fcm_token: fcm_token ?? this.fcm_token,
      os_name: os_name ?? this.os_name,
      os_version: os_version ?? this.os_version,
      created_date: created_date ?? this.created_date,
      last_login_date: last_login_date ?? this.last_login_date,
      deleted_date: deleted_date ?? this.deleted_date,
      social_type: social_type ?? this.social_type,
    );
  }



}

