import 'package:json_annotation/json_annotation.dart';
import '../event/event.dart';

part 'home_best_frame.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class HomeBestFrame {
  final int id;
  final bool isShow;
  final String previewImageFilepath;
  final String flippedImageFilepath;
  final String thumbnailImageFilepath;
  final String name;
  final int? eventId;
  final int orderIndex;
  final DateTime createdDate;
  final DateTime updatedDate;
  final DateTime? deletedDate;
  final Event? event;

  HomeBestFrame({
    required this.id,
    required this.isShow,
    required this.previewImageFilepath,
    required this.flippedImageFilepath,
    required this.thumbnailImageFilepath,
    required this.name,
    this.eventId,
    required this.orderIndex,
    required this.createdDate,
    required this.updatedDate,
    this.deletedDate,
    this.event,
  });

  factory HomeBestFrame.fromJson(Map<String, dynamic> json) =>
      _$HomeBestFrameFromJson(json);

  Map<String, dynamic> toJson() => _$HomeBestFrameToJson(this);
}
