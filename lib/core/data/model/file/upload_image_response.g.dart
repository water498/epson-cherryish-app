// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload_image_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UploadImageResponse _$UploadImageResponseFromJson(Map<String, dynamic> json) =>
    UploadImageResponse(
      originalFilepath: json['original_filepath'] as String,
      resizedFilepath: json['resized_filepath'] as String,
      width: (json['width'] as num).toInt(),
      height: (json['height'] as num).toInt(),
    );

Map<String, dynamic> _$UploadImageResponseToJson(
        UploadImageResponse instance) =>
    <String, dynamic>{
      'original_filepath': instance.originalFilepath,
      'resized_filepath': instance.resizedFilepath,
      'width': instance.width,
      'height': instance.height,
    };
