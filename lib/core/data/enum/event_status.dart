import 'package:json_annotation/json_annotation.dart';

@JsonEnum(valueField: 'value')
enum EventStatus {
  noReservation('NO_RESERVATION'),
  reservationRequested('RESERVATION_REQUESTED'),
  reservationApproved('RESERVATION_APPROVED'),
  reservationRejected('RESERVATION_REJECTED');

  final String value;
  const EventStatus(this.value);

  static EventStatus fromValue(String value) {
    return EventStatus.values.firstWhere((e) => e.value == value);
  }
}
