class Item {
  List<HomeTemplateModel> items;

  Item({
    required this.items
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      items: List<HomeTemplateModel>.from(json['photo_templates'].map((x) => HomeTemplateModel.fromJson(x))),
    );
  }


}

class HomeTemplateModel {

  String uid;
  String title;
  String sub_title;
  double latitude;
  double longitude;
  int zoom;
  String address;
  String thumbnail_image_filepath;
  int open_time;
  int close_time;
  int cost;
  int created_time;
  int updated_time;
  int like_count;


  HomeTemplateModel({
    required this.uid,
    required this.title,
    required this.sub_title,
    required this.latitude,
    required this.longitude,
    required this.zoom,
    required this.address,
    required this.thumbnail_image_filepath,
    required this.open_time,
    required this.close_time,
    required this.cost,
    required this.created_time,
    required this.updated_time,
    required this.like_count,
  });


  factory HomeTemplateModel.fromJson(Map<String, dynamic> json) {
    return HomeTemplateModel(
      uid: json['uid'] as String,
      title: json['title'] as String,
      sub_title: json['sub_title'] as String,
      latitude: json['latitude'] as double,
      longitude: json['longitude'] as double,
      zoom: json['zoom'] as int,
      address: json['address'] as String,
      thumbnail_image_filepath: json['thumbnail_image_filepath'] as String,
      open_time: json['open_time'] as int,
      close_time: json['close_time'] as int,
      cost: json['cost'] as int,
      created_time: json['created_time'] as int,
      updated_time: json['updated_time'] as int,
      like_count: json['like_count'] as int,
    );
  }


}