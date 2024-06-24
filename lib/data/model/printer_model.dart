class PrinterRequestModel {

  int user_uid;
  String photo_layout_uid;
  String printer_uid;
  String product_uid;

  PrinterRequestModel({
    required this.user_uid,
    required this.photo_layout_uid,
    required this.printer_uid,
    required this.product_uid,
  });

  Map<String, dynamic> toJson() {
    return {
      'user_uid': user_uid,
      'photo_layout_uid': photo_layout_uid,
      'printer_uid': printer_uid,
      'product_uid': product_uid,
    };
  }

}


class PrinterResponseModel{

  String a;

  PrinterResponseModel({
    required this.a,
  });

}