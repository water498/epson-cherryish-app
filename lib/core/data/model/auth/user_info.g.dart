// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserInfo _$UserInfoFromJson(Map<String, dynamic> json) => UserInfo(
      userId: (json['user_id'] as num).toInt(),
      email: json['email'] as String,
      name: json['name'] as String?,
      profileUrl: json['profile_url'] as String?,
      phoneNumberVerificationDate: json['phone_number_verification_date'] ==
              null
          ? null
          : DateTime.parse(json['phone_number_verification_date'] as String),
      accessType: json['access_type'] as String,
    );

Map<String, dynamic> _$UserInfoToJson(UserInfo instance) => <String, dynamic>{
      'user_id': instance.userId,
      'email': instance.email,
      'name': instance.name,
      'profile_url': instance.profileUrl,
      'phone_number_verification_date':
          instance.phoneNumberVerificationDate?.toIso8601String(),
      'access_type': instance.accessType,
    };
