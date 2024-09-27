class PrinterRequestModel {

  String photo_product_uid;
  int copies;

  PrinterRequestModel({
    required this.photo_product_uid,
    required this.copies
  });

  Map<String, dynamic> toJson() {
    return {
      'photo_product_uid': photo_product_uid,
      'copies': copies,
    };
  }

}


class PrinterResponseModel{

  String a;

  PrinterResponseModel({
    required this.a,
  });

}