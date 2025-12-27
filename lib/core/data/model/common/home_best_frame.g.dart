// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_best_frame.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeBestFrame _$HomeBestFrameFromJson(Map<String, dynamic> json) =>
    HomeBestFrame(
      id: (json['id'] as num).toInt(),
      isShow: json['is_show'] as bool,
      previewImageFilepath: json['preview_image_filepath'] as String,
      flippedImageFilepath: json['flipped_image_filepath'] as String,
      thumbnailImageFilepath: json['thumbnail_image_filepath'] as String,
      name: json['name'] as String,
      eventId: (json['event_id'] as num?)?.toInt(),
      orderIndex: (json['order_index'] as num).toInt(),
      createdDate: DateTime.parse(json['created_date'] as String),
      updatedDate: DateTime.parse(json['updated_date'] as String),
      deletedDate: json['deleted_date'] == null
          ? null
          : DateTime.parse(json['deleted_date'] as String),
      event: json['event'] == null
          ? null
          : Event.fromJson(json['event'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$HomeBestFrameToJson(HomeBestFrame instance) =>
    <String, dynamic>{
      'id': instance.id,
      'is_show': instance.isShow,
      'preview_image_filepath': instance.previewImageFilepath,
      'flipped_image_filepath': instance.flippedImageFilepath,
      'thumbnail_image_filepath': instance.thumbnailImageFilepath,
      'name': instance.name,
      'event_id': instance.eventId,
      'order_index': instance.orderIndex,
      'created_date': instance.createdDate.toIso8601String(),
      'updated_date': instance.updatedDate.toIso8601String(),
      'deleted_date': instance.deletedDate?.toIso8601String(),
      'event': instance.event,
    };
