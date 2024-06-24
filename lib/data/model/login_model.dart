import 'dart:io';

class LoginRequestModel{

  String name;
  String social_type;
  String social_id;
  String? fcm_token;
  String? birth;
  String? phone;
  String email;
  String device;
  String os;
  String os_version;

  String? profileUrl;
  String? iapReceipt;

  LoginRequestModel({
    required this.name,
    required this.social_type,
    required this.social_id,
    this.fcm_token,
    this.birth,
    this.phone,
    required this.email,
    required this.device,
    required this.os,
    required this.os_version,
    this.profileUrl,
    this.iapReceipt,
  }){
    os = Platform.isIOS ? "ios" : "aos";
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = {
      'name': name,
      'social_type': social_type,
      'social_id': social_id,
      'fcm_token': fcm_token,
      'birth': birth,
      'phone': phone,
      'email': email,
      'device': device,
      'os': os,
      'os_version': os_version,
      'profile_url': profileUrl,
      'iap_receipt' : iapReceipt,
    };

    json.removeWhere((key, value) => value == null || value == '');

    return json;
  }


}

class LoginResponseModel {
  UserInfoResponseModel? user;
  String? accessToken;

  LoginResponseModel({
    this.user,
    this.accessToken
  });

  factory LoginResponseModel.fromJson(Map<String, dynamic> json) {
    return LoginResponseModel(
      user: json['user'] != null ? UserInfoResponseModel.fromJson(json['user']) : null,
      accessToken: json['access_token'],
    );
  }

}




class UserInfoResponseModel {
  String? kakaoId;
  String? appleId;
  String? googleId;
  String? naverId;
  String? socialType;
  int? uid;
  int? createdTime; // 4/1 date -> timestamp
  String? name;
  String? fcmToken;
  String? birth;
  String? phone;
  String? email;
  String? deviceType;
  String? osType;
  String? profileUrl;
  String? updateTime;


  UserInfoResponseModel({
    this.kakaoId,
    this.appleId,
    this.googleId,
    this.naverId,
    this.socialType,
    this.uid,
    this.createdTime,
    this.name,
    this.fcmToken,
    this.birth,
    this.phone,
    this.email,
    this.deviceType,
    this.profileUrl,
    this.osType,
    this.updateTime,
  });

  factory UserInfoResponseModel.fromJson(Map<String, dynamic> json) {
    return UserInfoResponseModel(
      kakaoId: json['kakao_id'],
      appleId: json['apple_id'],
      googleId: json['google_id'],
      naverId: json['naver_id'],
      socialType: json['social_type'],
      uid: json['uid'],
      createdTime: json['created_time'],
      name: json['name'],
      fcmToken: json['fcm_token'],
      birth: json['birth'],
      phone: json['phone'],
      email: json['email'],
      deviceType: json['device_type'],
      profileUrl: json['profile_url'],
      osType: json['os_type'],
      updateTime: json['update_time'],
    );
  }
}

