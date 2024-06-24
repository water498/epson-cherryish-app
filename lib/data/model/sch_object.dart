class SCHObject {

  int version;

  String uid;
  String type;

  String filter;

  bool is_user_def;

  double opacity;
  double scale;
  double rotation;
  String background_color;
  double anchor_x;
  double anchor_y;
  double x;
  double y;
  double width;
  double height;
  double z_index;
  bool? visible;

  double? border_radius;
  String? border_color;
  double? border_width;

  // image
  String? image_filename;
  String? mask_filename;

  // text
  double? text_size;
  double? text_original_size;
  String? text_color;
  double? text_align_x;
  double? text_align_y;
  bool? is_match;
  String? text;
  String? font_name;
  double? text_linespacing;
  double? text_letter_spacing;




  SCHObject({
    required this.version,

    required this.uid,
    required this.type,
    required this.filter,
    required this.is_user_def,
    required this.opacity,
    required this.scale,
    required this.rotation,
    required this.background_color,
    required this.anchor_x,
    required this.anchor_y,
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    required  this.z_index,
    this.visible,


    this.border_radius,
    this.border_color,
    this.border_width,


    this.image_filename,
    this.mask_filename,


    this.text_size,
    this.text_original_size,
    this.text_color,
    this.text_align_x,
    this.text_align_y,
    this.is_match,
    this.text,
    this.font_name,
    this.text_linespacing,
    this.text_letter_spacing,
  });

}