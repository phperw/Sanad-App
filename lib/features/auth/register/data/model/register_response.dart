import 'package:json_annotation/json_annotation.dart';

import '../../../login/data/models/login_response.dart';

part 'register_response.g.dart';

@JsonSerializable()
class RegisterResponse {
  final bool success;
  final String message;
  final String accessToken;
  final String refreshToken;
  final UserModel user;

  const RegisterResponse({
    required this.success,
    required this.message,
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  factory RegisterResponse.fromJson(Map<String, dynamic> json) =>
      _$RegisterResponseFromJson(json);
}
