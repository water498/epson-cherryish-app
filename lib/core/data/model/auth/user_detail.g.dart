// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDetail _$UserDetailFromJson(Map<String, dynamic> json) => UserDetail(
      userId: (json['user_id'] as num).toInt(),
      email: json['email'] as String,
      name: json['name'] as String?,
      phoneNumber: json['phone_number'] as String?,
      phoneNumberVerificationDate: json['phone_number_verification_date'] ==
              null
          ? null
          : DateTime.parse(json['phone_number_verification_date'] as String),
      profileUrl: json['profile_url'] as String?,
      socialType:
          $enumDecodeNullable(_$SocialLoginTypeEnumMap, json['social_type']),
      status: $enumDecodeNullable(_$UserStatusEnumMap, json['status']),
      lastLoginDate: json['last_login_date'] == null
          ? null
          : DateTime.parse(json['last_login_date'] as String),
    );

Map<String, dynamic> _$UserDetailToJson(UserDetail instance) =>
    <String, dynamic>{
      'user_id': instance.userId,
      'email': instance.email,
      'name': instance.name,
      'phone_number': instance.phoneNumber,
      'phone_number_verification_date':
          instance.phoneNumberVerificationDate?.toIso8601String(),
      'profile_url': instance.profileUrl,
      'social_type': _$SocialLoginTypeEnumMap[instance.socialType],
      'status': _$UserStatusEnumMap[instance.status],
      'last_login_date': instance.lastLoginDate?.toIso8601String(),
    };

const _$SocialLoginTypeEnumMap = {
  SocialLoginType.google: 'GOOGLE',
  SocialLoginType.apple: 'APPLE',
  SocialLoginType.kakao: 'KAKAO',
  SocialLoginType.naver: 'NAVER',
};

const _$UserStatusEnumMap = {
  UserStatus.active: 'ACTIVE',
  UserStatus.blocked: 'BLOCKED',
};
