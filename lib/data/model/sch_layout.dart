class SCHLayout {

  int version;

  String background_color;
  int width_pixel;
  int height_pixel;
  String uid;
  String image_filename;
  String category_uid;
  String tags;

  SCHLayout({
    required this.version,

    required this.background_color,
    required this.width_pixel,
    required this.height_pixel,
    required this.uid,
    required this.image_filename,
    required this.category_uid,
    required this.tags,
  });

}