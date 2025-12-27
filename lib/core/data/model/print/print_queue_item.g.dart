// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'print_queue_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrintQueueResponse _$PrintQueueResponseFromJson(Map<String, dynamic> json) =>
    PrintQueueResponse(
      count: (json['count'] as num).toInt(),
      items: (json['items'] as List<dynamic>)
          .map((e) => PrintQueueItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PrintQueueResponseToJson(PrintQueueResponse instance) =>
    <String, dynamic>{
      'count': instance.count,
      'items': instance.items,
    };

PrintQueueItem _$PrintQueueItemFromJson(Map<String, dynamic> json) =>
    PrintQueueItem(
      id: (json['id'] as num).toInt(),
      imageFilepath: json['image_filepath'] as String,
      originalImageFilepath: json['original_image_filepath'] as String,
      thumbnailFilepath: json['thumbnail_filepath'] as String,
      status: $enumDecode(_$PrintQueueStatusEnumMap, json['status']),
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
      printedAt: json['printed_at'] == null
          ? null
          : DateTime.parse(json['printed_at'] as String),
      mobileUser: PrintQueueMobileUser.fromJson(
          json['mobile_user'] as Map<String, dynamic>),
      printer:
          PrintQueuePrinter.fromJson(json['printer'] as Map<String, dynamic>),
      event: PrintQueueEvent.fromJson(json['event'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PrintQueueItemToJson(PrintQueueItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'image_filepath': instance.imageFilepath,
      'original_image_filepath': instance.originalImageFilepath,
      'thumbnail_filepath': instance.thumbnailFilepath,
      'status': _$PrintQueueStatusEnumMap[instance.status]!,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
      'printed_at': instance.printedAt?.toIso8601String(),
      'mobile_user': instance.mobileUser,
      'printer': instance.printer,
      'event': instance.event,
    };

const _$PrintQueueStatusEnumMap = {
  PrintQueueStatus.none: 'NONE',
  PrintQueueStatus.wait: 'WAIT',
  PrintQueueStatus.printing: 'PRINTING',
  PrintQueueStatus.completed: 'COMPLETED',
  PrintQueueStatus.error: 'ERROR',
};

PrintQueueMobileUser _$PrintQueueMobileUserFromJson(
        Map<String, dynamic> json) =>
    PrintQueueMobileUser(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      email: json['email'] as String,
      profileUrl: json['profile_url'] as String?,
      phoneNumber: json['phone_number'] as String,
      phoneNumberVerificationDate: json['phone_number_verification_date'] ==
              null
          ? null
          : DateTime.parse(json['phone_number_verification_date'] as String),
    );

Map<String, dynamic> _$PrintQueueMobileUserToJson(
        PrintQueueMobileUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'email': instance.email,
      'profile_url': instance.profileUrl,
      'phone_number': instance.phoneNumber,
      'phone_number_verification_date':
          instance.phoneNumberVerificationDate?.toIso8601String(),
    };

PrintQueuePrinter _$PrintQueuePrinterFromJson(Map<String, dynamic> json) =>
    PrintQueuePrinter(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );

Map<String, dynamic> _$PrintQueuePrinterToJson(PrintQueuePrinter instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };

PrintQueueEvent _$PrintQueueEventFromJson(Map<String, dynamic> json) =>
    PrintQueueEvent(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      thumbnailFilepath: json['thumbnail_filepath'] as String,
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: DateTime.parse(json['end_date'] as String),
    );

Map<String, dynamic> _$PrintQueueEventToJson(PrintQueueEvent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'thumbnail_filepath': instance.thumbnailFilepath,
      'start_date': instance.startDate.toIso8601String(),
      'end_date': instance.endDate.toIso8601String(),
    };
