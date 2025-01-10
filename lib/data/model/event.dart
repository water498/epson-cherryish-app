
class EventModel {
  final int id;
  final String payment_status;
  final String sale_status;
  final bool sale_enable;
  final String payment_type; // sponser | prepayment 결제 X, postpayment 결제 O
  final bool need_using_fee;
  final String event_name;
  final String place_name;
  final DateTime start_date;
  final DateTime end_date;
  final String access_type;
  final String address;
  final String address_detail;
  final bool show_address;
  final String map_pin_image_filepath;
  final String thumbnail_image_filepath;
  final double latitude;
  final double longitude;
  final String tags;
  final String og_url;
  final String qr_image_filepath;
  final String web_link;
  final DateTime created_date;
  final DateTime updated_date;
  final DateTime? deleted_date;
  final int popularity_score;
  final int partner_id;

  EventModel({
    required this.id,
    required this.payment_status,
    required this.sale_status,
    required this.sale_enable,
    required this.payment_type,
    required this.need_using_fee,
    required this.event_name,
    required this.place_name,
    required this.start_date,
    required this.end_date,
    required this.access_type,
    required this.address,
    required this.address_detail,
    required this.show_address,
    required this.map_pin_image_filepath,
    required this.thumbnail_image_filepath,
    required this.latitude,
    required this.longitude,
    required this.tags,
    required this.og_url,
    required this.qr_image_filepath,
    required this.web_link,
    required this.created_date,
    required this.updated_date,
    this.deleted_date,
    required this.popularity_score,
    required this.partner_id,
  });

  factory EventModel.fromJson(Map<String, dynamic> json) {
    return EventModel(
      id: json['id'],
      payment_status: json['payment_status'],
      sale_status: json['sale_status'] ?? '',
      sale_enable: json['sale_enable'] ?? false,
      payment_type: json['payment_type'] ?? '',
      need_using_fee: json['need_using_fee'] ?? false,
      event_name: json['event_name'] ?? '',
      place_name: json['place_name'] ?? '',
      start_date: DateTime.parse(json['start_date']),
      end_date: DateTime.parse(json['end_date']),
      access_type: json['access_type'] ?? '',
      address: json['address'] ?? '',
      address_detail: json['address_detail'] ?? '',
      show_address: json['show_address'] ?? true,
      map_pin_image_filepath: json['map_pin_image_filepath'] ?? '',
      thumbnail_image_filepath: json['thumbnail_image_filepath'] ?? '',
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
      tags: json['tags'] ?? '',
      og_url: json['og_url'] ?? '',
      qr_image_filepath: json['qr_image_filepath'] ?? '',
      web_link: json['web_link'] ?? '',
      created_date: DateTime.parse(json['created_date']),
      updated_date: DateTime.parse(json['updated_date']),
      deleted_date: json['deleted_date'] != null ? DateTime.parse(json['deleted_date']) : null,
      popularity_score: json['popularity_score'] ?? -1,
      partner_id: json['partner_id'],
    );
  }

  static List<EventModel> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => EventModel.fromJson(json)).toList();
  }

}