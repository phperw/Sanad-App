import 'package:json_annotation/json_annotation.dart';

part 'login_request.g.dart';

@JsonSerializable()
class LoginRequest {
  @JsonKey(name: 'nationalId')
  final String nationalId;

  @JsonKey(name: 'password')
  final String password;

  const LoginRequest({required this.nationalId, required this.password});

  Map<String, dynamic> toJson() => _$LoginRequestToJson(this);
}
