// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event_detail_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EventDetailResponse _$EventDetailResponseFromJson(Map<String, dynamic> json) =>
    EventDetailResponse(
      event: Event.fromJson(json['event'] as Map<String, dynamic>),
      editorFrames: (json['editor_frames'] as List<dynamic>)
          .map((e) => EditorFrame.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$EventDetailResponseToJson(
        EventDetailResponse instance) =>
    <String, dynamic>{
      'event': instance.event,
      'editor_frames': instance.editorFrames,
    };
