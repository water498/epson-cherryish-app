import 'models.dart';

class CommonFailModel{
  String? url;
  String? reason; // TOKEN_EMPTY, TOKEN_EXPIRED, BAD_ACCESS
  // String? message;

  CommonFailModel({
    required this.url,
    required this.reason,
    // required this.message,
  });

  factory CommonFailModel.fromJson(Map<String, dynamic> json) {
    return CommonFailModel(
      url: json['url'],
      reason: json['reason'],
      // message: json['message'],
    );
  }
}


class CommonResponseModel {
  CommonSuccessModel? successModel;
  CommonFailModel? failModel;
  int? statusCode;

  CommonResponseModel({
    this.successModel,
    this.failModel,
    this.statusCode,
  });
}



class CommonSuccessModel{
  String? result;
  dynamic content;

  CommonSuccessModel({
    required this.result,
    required this.content,
  });

  factory CommonSuccessModel.fromJson(Map<String, dynamic> json) {
    return CommonSuccessModel(
      result: json['result'],
      content: json['content'],
    );
  }
}