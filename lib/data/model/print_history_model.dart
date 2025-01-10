class PrintHistoryModel {

  final int id;
  final int printer_id;
  final int mobile_user_id;
  final int partner_user_id;
  final int event_id;
  final String event_name;
  final String? mobile_user_name;
  final String mobile_user_phone_number;
  final String? print_filepath;
  final String status;
  final DateTime? printing_date;
  final DateTime created_date;
  final DateTime updated_date;
  final String merchant_uid; //  none 이냐 아니냐 무료 아니냐 구분 가능




  // 생성자
  PrintHistoryModel({
    required this.id,
    required this.printer_id,
    required this.mobile_user_id,
    required this.partner_user_id,
    required this.event_id,
    required this.event_name,
    this.mobile_user_name,
    required this.mobile_user_phone_number,
    this.print_filepath,
    required this.status,
    this.printing_date,
    required this.created_date,
    required this.updated_date,
    required this.merchant_uid,
  });

  factory PrintHistoryModel.fromJson(Map<String, dynamic> json) {
    return PrintHistoryModel(
      id: json['id'],
      printer_id: json['printer_id'],
      mobile_user_id: json['mobile_user_id'],
      partner_user_id: json['partner_user_id'],
      event_id: json['event_id'],
      event_name: json['event_name'],
      mobile_user_name: json['mobile_user_name'],
      mobile_user_phone_number: json['mobile_user_phone_number'],
      print_filepath: json['print_filepath'],
      status: json['status'],
      printing_date: json['printing_date'] != null ? DateTime.parse(json['printing_date']) : null,
      created_date: DateTime.parse(json['created_date']),
      updated_date: DateTime.parse(json['updated_date']),
      merchant_uid: json['merchant_uid'],
    );
  }

  static List<PrintHistoryModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => PrintHistoryModel.fromJson(json)).toList();
  }

}