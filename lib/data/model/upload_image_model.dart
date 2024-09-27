
/**
 * upload merged image response model
 * */
class UploadImageResponseModel {

  final String s3_filepath;
  final String filter_uid;

  UploadImageResponseModel({
    required this.s3_filepath,
    required this.filter_uid,
  });

  factory UploadImageResponseModel.fromJson(Map<String, dynamic> json) {
    return UploadImageResponseModel(
      filter_uid: json['filter_uid'] as String,
      s3_filepath: json['s3_filepath'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'filter_uid': filter_uid,
      's3_filepath': s3_filepath,
    };
  }


}