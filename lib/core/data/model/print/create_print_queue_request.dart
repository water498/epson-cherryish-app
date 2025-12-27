import 'package:json_annotation/json_annotation.dart';

part 'create_print_queue_request.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class CreatePrintQueueRequest {
  final int eventId;
  final int editorFrameId;
  final String filterLtFilepath;
  final String filterRtFilepath;
  final String filterLbFilepath;
  final String filterRbFilepath;

  CreatePrintQueueRequest({
    required this.eventId,
    required this.editorFrameId,
    required this.filterLtFilepath,
    required this.filterRtFilepath,
    required this.filterLbFilepath,
    required this.filterRbFilepath,
  });

  factory CreatePrintQueueRequest.fromJson(Map<String, dynamic> json) =>
      _$CreatePrintQueueRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreatePrintQueueRequestToJson(this);
}
