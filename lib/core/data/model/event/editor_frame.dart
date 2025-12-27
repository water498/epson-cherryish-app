import 'package:json_annotation/json_annotation.dart';
import '../../enum/enums.dart';

part 'editor_frame.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class EditorFrame {
  final int id;
  final String name;
  final EditorFrameType type;
  final int eventId;
  final String? originalMergedFrameImageFilepath;
  final String? resizedMergedFrameImageFilepath;
  final String? originalFrameImageFilepath;
  final String? resizedFrameImageFilepath;
  final String? originalFilterLtImageFilepath;
  final String? resizedFilterLtImageFilepath;
  final String? originalFilterRtImageFilepath;
  final String? resizedFilterRtImageFilepath;
  final String? originalFilterLbImageFilepath;
  final String? resizedFilterLbImageFilepath;
  final String? originalFilterRbImageFilepath;
  final String? resizedFilterRbImageFilepath;
  final DateTime createdDate;
  final DateTime updatedDate;
  final DateTime? deletedDate;

  EditorFrame({
    required this.id,
    required this.name,
    required this.type,
    required this.eventId,
    this.originalMergedFrameImageFilepath,
    this.resizedMergedFrameImageFilepath,
    this.originalFrameImageFilepath,
    this.resizedFrameImageFilepath,
    this.originalFilterLtImageFilepath,
    this.resizedFilterLtImageFilepath,
    this.originalFilterRtImageFilepath,
    this.resizedFilterRtImageFilepath,
    this.originalFilterLbImageFilepath,
    this.resizedFilterLbImageFilepath,
    this.originalFilterRbImageFilepath,
    this.resizedFilterRbImageFilepath,
    required this.createdDate,
    required this.updatedDate,
    this.deletedDate,
  });

  factory EditorFrame.fromJson(Map<String, dynamic> json) =>
      _$EditorFrameFromJson(json);

  Map<String, dynamic> toJson() => _$EditorFrameToJson(this);
}
