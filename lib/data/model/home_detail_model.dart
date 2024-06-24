
import 'package:flutter/cupertino.dart';

class PhotoTemplate {

  String uid;
  String title;
  String sub_title;
  double latitude;
  double longitude;
  int zoom;
  String address;
  String original_image_filepath;
  String thumbnail_image_filepath;
  int open_time;
  int close_time;
  int? cost;
  int created_time;
  int updated_time;
  int like_count;
  String description;
  bool enable;


  PhotoTemplate({
    required this.uid,
    required this.title,
    required this.sub_title,
    required this.latitude,
    required this.longitude,
    required this.zoom,
    required this.address,
    required this.original_image_filepath,
    required this.thumbnail_image_filepath,
    required this.open_time,
    required this.close_time,
    required this.cost,
    required this.created_time,
    required this.updated_time,
    required this.like_count,
    required this.description,
    required this.enable,
  });

  factory PhotoTemplate.fromJson(Map<String, dynamic> allJson) {

    Map<String, dynamic> json = allJson['photo_template'];

    return PhotoTemplate(
      uid: json['uid'] as String,
      title: json['title'] as String,
      sub_title: json['sub_title'] as String,
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
      zoom: json['zoom'] as int,
      address: json['address'] as String,
      original_image_filepath: json['original_image_filepath'] as String,
      thumbnail_image_filepath: json['thumbnail_image_filepath'] as String,
      open_time: json['open_time'] as int,
      close_time: json['close_time'] as int,
      cost: json['cost'] as int?,
      created_time: json['created_time'] as int,
      updated_time: json['updated_time'] as int,
      like_count: json['like_count'] as int,
      description: json['description'] as String,
      enable: json['enable'] as bool,
    );
  }

}


class PhotoLayouts {

  List<PhotoLayout> photoLayouts;

  PhotoLayouts({
    required this.photoLayouts,
  });

  factory PhotoLayouts.fromJson(Map<String, dynamic> json) {
    return PhotoLayouts(
      photoLayouts: List<PhotoLayout>.from(json['photo_layouts'].map((x) => PhotoLayout.fromJson(x))),
    );
  }

}

class PhotoLayout {

  String uid;
  String photo_template_uid;
  int width;
  int height;
  String background_color;
  String original_image_filepath;
  String thumbnail_image_filepath;

  PhotoLayout({
    required this.uid,
    required this.photo_template_uid,
    required this.width,
    required this.height,
    required this.background_color,
    required this.original_image_filepath,
    required this.thumbnail_image_filepath,
  });

  factory PhotoLayout.fromJson(Map<String, dynamic> json) {

    return PhotoLayout(
      uid: json['uid'] as String,
      photo_template_uid: json['photo_template_uid'] as String,
      width: json['width'] as int,
      height: json['height'] as int,
      background_color: json['background_color'] as String,
      original_image_filepath: json['original_image_filepath'] as String,
      thumbnail_image_filepath: json['thumbnail_image_filepath'] as String,
    );
  }


}





class PhotoFilters {

  List<PhotoFilter> photoFilters;

  PhotoFilters({
    required this.photoFilters,
  });

  factory PhotoFilters.fromJson(Map<String, dynamic> json) {
    return PhotoFilters(
      photoFilters: List<PhotoFilter>.from(json['photo_filters'].map((x) => PhotoFilter.fromJson(x))),
    );
  }

}

class PhotoFilter {

  String uid;
  String photo_template_uid;
  String photo_layout_uid;
  int x;
  int y;
  int width;
  int height;
  String original_image_filepath;
  String thumbnail_image_filepath;

  PhotoFilter({
    required this.uid,
    required this.photo_template_uid,
    required this.photo_layout_uid,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    required this.original_image_filepath,
    required this.thumbnail_image_filepath,
  });

  factory PhotoFilter.fromJson(Map<String, dynamic> json) {

    return PhotoFilter(
      uid: json['uid'] as String,
      photo_template_uid: json['photo_template_uid'] as String,
      photo_layout_uid: json['photo_layout_uid'] as String,
      x: json['x'] as int,
      y: json['y'] as int,
      width: json['width'] as int,
      height: json['height'] as int,
      original_image_filepath: json['original_image_filepath'] as String,
      thumbnail_image_filepath: json['thumbnail_image_filepath'] as String,
    );
  }

}