import 'models.dart';

class PrinterAccessResponseModel {

  final String result;
  final int? print_queue_id; // result == "posible" 인 경우만 존재
  final UserPrivateModel userModel;

  PrinterAccessResponseModel({
    required this.result,
    this.print_queue_id,
    required this.userModel
  });

  factory PrinterAccessResponseModel.fromJson(Map<String, dynamic> json) {
    return PrinterAccessResponseModel(
      result : json['result'],
      print_queue_id : json['print_queue_id'],
      userModel: UserPrivateModel.fromJson(json['user']),
    );
  }

}





class RequestPrintResponseModel {

  final int wait_count;
  final UserPrivateModel userModel;

  RequestPrintResponseModel({
    required this.wait_count,
    required this.userModel
  });

  factory RequestPrintResponseModel.fromJson(Map<String, dynamic> json) {
    return RequestPrintResponseModel(
      wait_count : json['wait_count'],
      userModel: UserPrivateModel.fromJson(json['user']),
    );
  }

}

