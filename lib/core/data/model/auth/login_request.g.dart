// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginRequest _$LoginRequestFromJson(Map<String, dynamic> json) => LoginRequest(
      email: json['email'] as String,
      socialId: json['social_id'] as String,
      socialType: $enumDecode(_$SocialLoginTypeEnumMap, json['social_type']),
      name: json['name'] as String?,
      phoneNumber: json['phone_number'] as String?,
      profileUrl: json['profile_url'] as String?,
      fcmToken: json['fcm_token'] as String?,
      osName: json['os_name'] as String?,
      osVersion: json['os_version'] as String?,
    );

Map<String, dynamic> _$LoginRequestToJson(LoginRequest instance) =>
    <String, dynamic>{
      'email': instance.email,
      'social_id': instance.socialId,
      'social_type': _$SocialLoginTypeEnumMap[instance.socialType]!,
      'name': instance.name,
      'phone_number': instance.phoneNumber,
      'profile_url': instance.profileUrl,
      'fcm_token': instance.fcmToken,
      'os_name': instance.osName,
      'os_version': instance.osVersion,
    };

const _$SocialLoginTypeEnumMap = {
  SocialLoginType.google: 'GOOGLE',
  SocialLoginType.apple: 'APPLE',
  SocialLoginType.kakao: 'KAKAO',
  SocialLoginType.naver: 'NAVER',
};
