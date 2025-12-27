// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'editor_frame.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EditorFrame _$EditorFrameFromJson(Map<String, dynamic> json) => EditorFrame(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      type: $enumDecode(_$EditorFrameTypeEnumMap, json['type']),
      eventId: (json['event_id'] as num).toInt(),
      originalMergedFrameImageFilepath:
          json['original_merged_frame_image_filepath'] as String?,
      resizedMergedFrameImageFilepath:
          json['resized_merged_frame_image_filepath'] as String?,
      originalFrameImageFilepath:
          json['original_frame_image_filepath'] as String?,
      resizedFrameImageFilepath:
          json['resized_frame_image_filepath'] as String?,
      originalFilterLtImageFilepath:
          json['original_filter_lt_image_filepath'] as String?,
      resizedFilterLtImageFilepath:
          json['resized_filter_lt_image_filepath'] as String?,
      originalFilterRtImageFilepath:
          json['original_filter_rt_image_filepath'] as String?,
      resizedFilterRtImageFilepath:
          json['resized_filter_rt_image_filepath'] as String?,
      originalFilterLbImageFilepath:
          json['original_filter_lb_image_filepath'] as String?,
      resizedFilterLbImageFilepath:
          json['resized_filter_lb_image_filepath'] as String?,
      originalFilterRbImageFilepath:
          json['original_filter_rb_image_filepath'] as String?,
      resizedFilterRbImageFilepath:
          json['resized_filter_rb_image_filepath'] as String?,
      createdDate: DateTime.parse(json['created_date'] as String),
      updatedDate: DateTime.parse(json['updated_date'] as String),
      deletedDate: json['deleted_date'] == null
          ? null
          : DateTime.parse(json['deleted_date'] as String),
    );

Map<String, dynamic> _$EditorFrameToJson(EditorFrame instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': _$EditorFrameTypeEnumMap[instance.type]!,
      'event_id': instance.eventId,
      'original_merged_frame_image_filepath':
          instance.originalMergedFrameImageFilepath,
      'resized_merged_frame_image_filepath':
          instance.resizedMergedFrameImageFilepath,
      'original_frame_image_filepath': instance.originalFrameImageFilepath,
      'resized_frame_image_filepath': instance.resizedFrameImageFilepath,
      'original_filter_lt_image_filepath':
          instance.originalFilterLtImageFilepath,
      'resized_filter_lt_image_filepath': instance.resizedFilterLtImageFilepath,
      'original_filter_rt_image_filepath':
          instance.originalFilterRtImageFilepath,
      'resized_filter_rt_image_filepath': instance.resizedFilterRtImageFilepath,
      'original_filter_lb_image_filepath':
          instance.originalFilterLbImageFilepath,
      'resized_filter_lb_image_filepath': instance.resizedFilterLbImageFilepath,
      'original_filter_rb_image_filepath':
          instance.originalFilterRbImageFilepath,
      'resized_filter_rb_image_filepath': instance.resizedFilterRbImageFilepath,
      'created_date': instance.createdDate.toIso8601String(),
      'updated_date': instance.updatedDate.toIso8601String(),
      'deleted_date': instance.deletedDate?.toIso8601String(),
    };

const _$EditorFrameTypeEnumMap = {
  EditorFrameType.typeA: 'TYPE_A',
  EditorFrameType.typeB: 'TYPE_B',
  EditorFrameType.typeC: 'TYPE_C',
  EditorFrameType.typeD: 'TYPE_D',
  EditorFrameType.typeE: 'TYPE_E',
};
