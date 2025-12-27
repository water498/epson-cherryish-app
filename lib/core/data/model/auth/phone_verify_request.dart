import 'package:json_annotation/json_annotation.dart';

part 'phone_verify_request.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class PhoneVerifyRequest {
  final String phoneNumber;

  PhoneVerifyRequest({
    required this.phoneNumber,
  });

  factory PhoneVerifyRequest.fromJson(Map<String, dynamic> json) =>
      _$PhoneVerifyRequestFromJson(json);

  Map<String, dynamic> toJson() => _$PhoneVerifyRequestToJson(this);
}
