import 'package:json_annotation/json_annotation.dart';

part 'upload_image_response.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class UploadImageResponse {
  final String originalFilepath;
  final String resizedFilepath;
  final int width;
  final int height;

  UploadImageResponse({
    required this.originalFilepath,
    required this.resizedFilepath,
    required this.width,
    required this.height,
  });

  factory UploadImageResponse.fromJson(Map<String, dynamic> json) =>
      _$UploadImageResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UploadImageResponseToJson(this);
}
