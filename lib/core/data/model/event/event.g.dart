// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Event _$EventFromJson(Map<String, dynamic> json) => Event(
      id: (json['id'] as num).toInt(),
      eventName: json['event_name'] as String?,
      mapPinImageFilepath: json['map_pin_image_filepath'] as String?,
      thumbnailImageFilepath: json['thumbnail_image_filepath'] as String?,
      startDate: DateTime.parse(json['start_date'] as String),
      endDate: DateTime.parse(json['end_date'] as String),
      address: json['address'] as String,
      addressDetail: json['address_detail'] as String,
      showAddress: json['show_address'] as bool,
      placeName: json['place_name'] as String,
      longitude: (json['longitude'] as num).toDouble(),
      latitude: (json['latitude'] as num).toDouble(),
      tags: json['tags'] as String?,
      qrImageFilepath: json['qr_image_filepath'] as String?,
      webLink: json['web_link'] as String?,
      popularityScore: (json['popularity_score'] as num?)?.toInt(),
      createdDate: DateTime.parse(json['created_date'] as String),
      updatedDate: DateTime.parse(json['updated_date'] as String),
      deletedDate: json['deleted_date'] == null
          ? null
          : DateTime.parse(json['deleted_date'] as String),
    );

Map<String, dynamic> _$EventToJson(Event instance) => <String, dynamic>{
      'id': instance.id,
      'event_name': instance.eventName,
      'map_pin_image_filepath': instance.mapPinImageFilepath,
      'thumbnail_image_filepath': instance.thumbnailImageFilepath,
      'start_date': instance.startDate.toIso8601String(),
      'end_date': instance.endDate.toIso8601String(),
      'address': instance.address,
      'address_detail': instance.addressDetail,
      'show_address': instance.showAddress,
      'place_name': instance.placeName,
      'longitude': instance.longitude,
      'latitude': instance.latitude,
      'tags': instance.tags,
      'qr_image_filepath': instance.qrImageFilepath,
      'web_link': instance.webLink,
      'popularity_score': instance.popularityScore,
      'created_date': instance.createdDate.toIso8601String(),
      'updated_date': instance.updatedDate.toIso8601String(),
      'deleted_date': instance.deletedDate?.toIso8601String(),
    };
