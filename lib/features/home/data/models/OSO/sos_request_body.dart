import 'package:json_annotation/json_annotation.dart';
part 'sos_request_body.g.dart';
@JsonSerializable()
class SosSendRequestBody {
  final double latitude;
  final double longitude;

  const SosSendRequestBody({
    required this.latitude,
    required this.longitude,
  });

  factory SosSendRequestBody.fromJson(Map<String, dynamic> json) =>
      _$SosSendRequestBodyFromJson(json);

  Map<String, dynamic> toJson() => _$SosSendRequestBodyToJson(this);
}
