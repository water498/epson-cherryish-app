// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDetail _$UserDetailFromJson(Map<String, dynamic> json) => UserDetail(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String?,
      status: $enumDecodeNullable(_$UserStatusEnumMap, json['status']),
      email: json['email'] as String,
      phoneNumber: json['phone_number'] as String?,
      phoneNumberVerificationDate: json['phone_number_verification_date'] ==
              null
          ? null
          : DateTime.parse(json['phone_number_verification_date'] as String),
      profileUrl: json['profile_url'] as String?,
      socialId: json['social_id'] as String?,
      socialType:
          $enumDecodeNullable(_$SocialLoginTypeEnumMap, json['social_type']),
      fcmToken: json['fcm_token'] as String?,
      osName: json['os_name'] as String?,
      osVersion: json['os_version'] as String?,
      createdDate: json['created_date'] == null
          ? null
          : DateTime.parse(json['created_date'] as String),
      updatedDate: json['updated_date'] == null
          ? null
          : DateTime.parse(json['updated_date'] as String),
      deletedDate: json['deleted_date'] == null
          ? null
          : DateTime.parse(json['deleted_date'] as String),
      lastLoginDate: json['last_login_date'] == null
          ? null
          : DateTime.parse(json['last_login_date'] as String),
    );

Map<String, dynamic> _$UserDetailToJson(UserDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'status': _$UserStatusEnumMap[instance.status],
      'email': instance.email,
      'phone_number': instance.phoneNumber,
      'phone_number_verification_date':
          instance.phoneNumberVerificationDate?.toIso8601String(),
      'profile_url': instance.profileUrl,
      'social_id': instance.socialId,
      'social_type': _$SocialLoginTypeEnumMap[instance.socialType],
      'fcm_token': instance.fcmToken,
      'os_name': instance.osName,
      'os_version': instance.osVersion,
      'created_date': instance.createdDate?.toIso8601String(),
      'updated_date': instance.updatedDate?.toIso8601String(),
      'deleted_date': instance.deletedDate?.toIso8601String(),
      'last_login_date': instance.lastLoginDate?.toIso8601String(),
    };

const _$UserStatusEnumMap = {
  UserStatus.active: 'ACTIVE',
  UserStatus.blocked: 'BLOCKED',
};

const _$SocialLoginTypeEnumMap = {
  SocialLoginType.google: 'GOOGLE',
  SocialLoginType.apple: 'APPLE',
  SocialLoginType.kakao: 'KAKAO',
  SocialLoginType.naver: 'NAVER',
};
