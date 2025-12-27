import 'package:json_annotation/json_annotation.dart';
import '../../enum/enums.dart';

part 'print_queue.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class PrintQueue {
  final int id;
  final int eventId;
  final String? originalImageFilepath;
  final String? thumbnailImageFilepath;
  final PrintQueueStatus status;
  final DateTime? printingDate;
  final DateTime? printingRequestDate;
  final String? printingErrorMessage;
  final PrintErrorReportStatus? printErrorReportStatus;
  final String? printErrorReportMessage;
  final String? printErrorReportFilepath;
  final DateTime createdDate;
  final DateTime updatedDate;
  final DateTime? deletedDate;

  PrintQueue({
    required this.id,
    required this.eventId,
    this.originalImageFilepath,
    this.thumbnailImageFilepath,
    required this.status,
    this.printingDate,
    this.printingRequestDate,
    this.printingErrorMessage,
    this.printErrorReportStatus,
    this.printErrorReportMessage,
    this.printErrorReportFilepath,
    required this.createdDate,
    required this.updatedDate,
    this.deletedDate,
  });

  factory PrintQueue.fromJson(Map<String, dynamic> json) =>
      _$PrintQueueFromJson(json);

  Map<String, dynamic> toJson() => _$PrintQueueToJson(this);
}
