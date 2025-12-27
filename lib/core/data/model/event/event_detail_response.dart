import 'package:json_annotation/json_annotation.dart';
import 'package:seeya/core/data/model/event/event.dart';
import 'package:seeya/core/data/model/event/editor_frame.dart';

part 'event_detail_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class EventDetailResponse {
  final Event event;
  final List<EditorFrame> editorFrames;

  EventDetailResponse({
    required this.event,
    required this.editorFrames,
  });

  factory EventDetailResponse.fromJson(Map<String, dynamic> json) =>
      _$EventDetailResponseFromJson(json);

  Map<String, dynamic> toJson() => _$EventDetailResponseToJson(this);
}
