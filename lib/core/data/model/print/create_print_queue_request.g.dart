// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_print_queue_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreatePrintQueueRequest _$CreatePrintQueueRequestFromJson(
        Map<String, dynamic> json) =>
    CreatePrintQueueRequest(
      eventId: (json['event_id'] as num).toInt(),
      editorFrameId: (json['editor_frame_id'] as num).toInt(),
      filterLtFilepath: json['filter_lt_filepath'] as String,
      filterRtFilepath: json['filter_rt_filepath'] as String,
      filterLbFilepath: json['filter_lb_filepath'] as String,
      filterRbFilepath: json['filter_rb_filepath'] as String,
    );

Map<String, dynamic> _$CreatePrintQueueRequestToJson(
        CreatePrintQueueRequest instance) =>
    <String, dynamic>{
      'event_id': instance.eventId,
      'editor_frame_id': instance.editorFrameId,
      'filter_lt_filepath': instance.filterLtFilepath,
      'filter_rt_filepath': instance.filterRtFilepath,
      'filter_lb_filepath': instance.filterLbFilepath,
      'filter_rb_filepath': instance.filterRbFilepath,
    };
