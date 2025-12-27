// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'print_queue.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrintQueue _$PrintQueueFromJson(Map<String, dynamic> json) => PrintQueue(
      id: (json['id'] as num).toInt(),
      eventId: (json['event_id'] as num).toInt(),
      originalImageFilepath: json['original_image_filepath'] as String?,
      thumbnailImageFilepath: json['thumbnail_image_filepath'] as String?,
      status: $enumDecode(_$PrintQueueStatusEnumMap, json['status']),
      printingDate: json['printing_date'] == null
          ? null
          : DateTime.parse(json['printing_date'] as String),
      printingRequestDate: json['printing_request_date'] == null
          ? null
          : DateTime.parse(json['printing_request_date'] as String),
      printingErrorMessage: json['printing_error_message'] as String?,
      printErrorReportStatus: $enumDecodeNullable(
          _$PrintErrorReportStatusEnumMap, json['print_error_report_status']),
      printErrorReportMessage: json['print_error_report_message'] as String?,
      printErrorReportFilepath: json['print_error_report_filepath'] as String?,
      createdDate: DateTime.parse(json['created_date'] as String),
      updatedDate: DateTime.parse(json['updated_date'] as String),
      deletedDate: json['deleted_date'] == null
          ? null
          : DateTime.parse(json['deleted_date'] as String),
    );

Map<String, dynamic> _$PrintQueueToJson(PrintQueue instance) =>
    <String, dynamic>{
      'id': instance.id,
      'event_id': instance.eventId,
      'original_image_filepath': instance.originalImageFilepath,
      'thumbnail_image_filepath': instance.thumbnailImageFilepath,
      'status': _$PrintQueueStatusEnumMap[instance.status]!,
      'printing_date': instance.printingDate?.toIso8601String(),
      'printing_request_date': instance.printingRequestDate?.toIso8601String(),
      'printing_error_message': instance.printingErrorMessage,
      'print_error_report_status':
          _$PrintErrorReportStatusEnumMap[instance.printErrorReportStatus],
      'print_error_report_message': instance.printErrorReportMessage,
      'print_error_report_filepath': instance.printErrorReportFilepath,
      'created_date': instance.createdDate.toIso8601String(),
      'updated_date': instance.updatedDate.toIso8601String(),
      'deleted_date': instance.deletedDate?.toIso8601String(),
    };

const _$PrintQueueStatusEnumMap = {
  PrintQueueStatus.none: 'NONE',
  PrintQueueStatus.wait: 'WAIT',
  PrintQueueStatus.printing: 'PRINTING',
  PrintQueueStatus.completed: 'COMPLETED',
  PrintQueueStatus.error: 'ERROR',
};

const _$PrintErrorReportStatusEnumMap = {
  PrintErrorReportStatus.pending: 'PENDING',
  PrintErrorReportStatus.rejected: 'REJECTED',
  PrintErrorReportStatus.refunded: 'REFUNDED',
};
