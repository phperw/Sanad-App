import 'package:json_annotation/json_annotation.dart';

part 'sos_response.g.dart';

@JsonSerializable()
class SosResponse {
  final bool success;
  final String? message;
  @JsonKey(name: 'sos_id')
  final String? sosId;

  const SosResponse({required this.success, this.message, this.sosId});

  factory SosResponse.fromJson(Map<String, dynamic> json) =>
      _$SosResponseFromJson(json);

  Map<String, dynamic> toJson() => _$SosResponseToJson(this);
}
