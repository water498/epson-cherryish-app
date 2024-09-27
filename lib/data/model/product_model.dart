import 'package:seeya/data/model/models.dart';

class MergedProductRequestModel {

  String photoTemplateUid;
  String photoLayoutUid;
  List<UploadImageResponseModel> photoFilters;

  MergedProductRequestModel({
    required this.photoTemplateUid,
    required this.photoLayoutUid,
    required this.photoFilters,
  });

  factory MergedProductRequestModel.fromJson(Map<String, dynamic> json) {
    var list = json['photo_filters'] as List;
    List<UploadImageResponseModel> photoFilterList =
    list.map((i) => UploadImageResponseModel.fromJson(i)).toList();

    return MergedProductRequestModel(
      photoTemplateUid: json['photo_template_uid'] as String,
      photoLayoutUid: json['photo_layout_uid'] as String,
      photoFilters: photoFilterList,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'photo_template_uid': photoTemplateUid,
      'photo_layout_uid': photoLayoutUid,
      'photo_filters': photoFilters.map((v) => v.toJson()).toList(),
    };
  }

}


class MergedProductResponseModel {
  String uid;
  String photo_layout_uid;
  String photo_template_uid;
  String title;
  int user_uid;
  String status;
  String merged_original_image_filepath;
  String merged_thumbnail_image_filepath;
  int created_time;
  int updated_time;

  MergedProductResponseModel({
    required this.uid,
    required this.photo_layout_uid,
    required this.photo_template_uid,
    required this.title,
    required this.user_uid,
    required this.status,
    required this.merged_original_image_filepath,
    required this.merged_thumbnail_image_filepath,
    required this.created_time,
    required this.updated_time,
  });


  static List<MergedProductResponseModel> fromJsonList(Map<String, dynamic> json) {
    return List<MergedProductResponseModel>.from(
        json['photo_products'].map((item) => MergedProductResponseModel.fromJson(item as Map<String, dynamic>))
    );
  }



  factory MergedProductResponseModel.fromJson(Map<String, dynamic> json) {

    return MergedProductResponseModel(
      uid: json['uid'] as String,
      photo_layout_uid: json['photo_layout_uid'] as String,
      photo_template_uid: json['photo_template_uid'] as String,
      title: json['title'] as String,
      user_uid: json['user_uid'] as int,
      status: json['status'] as String,
      merged_original_image_filepath: json['merged_original_image_filepath'] as String,
      merged_thumbnail_image_filepath: json['merged_thumbnail_image_filepath'] as String,
      created_time: json['created_time'] as int,
      updated_time: json['updated_time'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'photo_layout_uid': photo_layout_uid,
      'photo_template_uid': photo_template_uid,
      'title': title,
      'user_uid': user_uid,
      'status': status,
      'merged_original_image_filepath': merged_original_image_filepath,
      'merged_thumbnail_image_filepath': merged_thumbnail_image_filepath,
      'created_time': created_time,
      'updated_time': updated_time,
    };
  }
}