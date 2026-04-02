import 'package:json_annotation/json_annotation.dart';
part 'register_request.g.dart';

@JsonSerializable()
class RegisterRequest {
  @JsonKey(name: 'fullName')
  final String fullName;

  @JsonKey(name: 'nationalId')
  final String nationalId;

  @JsonKey(name: 'email')
  final String email;

  @JsonKey(name: 'phone')
  final String phone;

  @JsonKey(name: 'dateOfBirth')
  final String dateOfBirth;

  @JsonKey(name: 'password')
  final String password;

  @JsonKey(name: 'confirmPassword')
  final String confirmPassword;

  const RegisterRequest({
    required this.fullName,
    required this.nationalId,
    required this.email,
    required this.phone,
    required this.dateOfBirth,
    required this.password,
    required this.confirmPassword,
  });

  Map<String, dynamic> toJson() => _$RegisterRequestToJson(this);
}
