class ReportErrorRequestModel {
  final int printer_id;
  final int mobile_user_id;
  final int partner_user_id;
  final int event_id;
  final String event_name;
  final String? mobile_user_name;
  final String mobile_user_phone_number;
  final String report_filepath;
  // final String report_status;
  final String? report_reason;
  final String? print_filepath;
  final String status;
  final DateTime? printing_date;

  ReportErrorRequestModel({
    required this.printer_id,
    required this.mobile_user_id,
    required this.partner_user_id,
    required this.event_id,
    required this.event_name,
    this.mobile_user_name,
    required this.mobile_user_phone_number,
    required this.report_filepath,
    // required this.report_status,
    this.report_reason,
    this.print_filepath,
    required this.status,
    this.printing_date,
  });

  Map<String, dynamic> toJson() {
    return {
      'printer_id': printer_id,
      'mobile_user_id': mobile_user_id,
      'partner_user_id': partner_user_id,
      'event_id': event_id,
      'event_name': event_name,
      'mobile_user_name': mobile_user_name,
      'mobile_user_phone_number': mobile_user_phone_number,
      'report_filepath': report_filepath,
      // 'report_status': report_status,
      'report_reason': report_reason,
      'print_filepath': print_filepath,
      'status': status,
      'printing_date': printing_date?.toIso8601String(),
    };
  }
}




class InquiryItemModel {

  final int id;
  final int printer_id;
  final int mobile_user_id;
  final int partner_user_id;
  final int event_id;
  final String event_name;
  final String? mobile_user_name;
  final String mobile_user_phone_number;
  final String? print_filepath;
  final String report_filepath;
  final String report_status;
  final String? report_reason;
  final String? report_answer;
  final DateTime? report_completed_date;
  final String status;
  final DateTime? printing_date;
  final DateTime created_date;
  final DateTime updated_date;

  InquiryItemModel({
    required this.id,
    required this.printer_id,
    required this.mobile_user_id,
    required this.partner_user_id,
    required this.event_id,
    required this.event_name,
    this.mobile_user_name,
    required this.mobile_user_phone_number,
    this.print_filepath,
    required this.report_filepath,
    required this.report_status,
    this.report_reason,
    this.report_answer,
    this.report_completed_date,
    required this.status,
    this.printing_date,
    required this.created_date,
    required this.updated_date,
  });

  factory InquiryItemModel.fromJson(Map<String, dynamic> json) {
    return InquiryItemModel(
      id: json['id'],
      printer_id: json['printer_id'],
      mobile_user_id: json['mobile_user_id'],
      partner_user_id: json['partner_user_id'],
      event_id: json['event_id'],
      event_name: json['event_name'],
      mobile_user_name: json['mobile_user_name'],
      mobile_user_phone_number: json['mobile_user_phone_number'],
      print_filepath: json['print_filepath'],
      report_filepath: json['report_filepath'],
      report_status: json['report_status'],
      report_reason: json['report_reason'],
      report_answer: json['report_answer'],
      report_completed_date: json['report_completed_date'] != null ? DateTime.parse(json['report_completed_date']) : null,
      status: json['status'],
      printing_date: json['printing_date'] != null ? DateTime.parse(json['printing_date']) : null,
      created_date: DateTime.parse(json['created_date']),
      updated_date: DateTime.parse(json['updated_date']),
    );
  }

  static List<InquiryItemModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => InquiryItemModel.fromJson(json)).toList();
  }

}