import 'package:json_annotation/json_annotation.dart';

part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse {
  final bool success;
  final String message;
  final String accessToken;
  final String refreshToken;
  final UserModel user;

  const LoginResponse({
    required this.success,
    required this.message,
    required this.accessToken,
    required this.refreshToken,
    required this.user,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);
}

@JsonSerializable()
class UserModel {
  final int id;
  final String fullName;
  final String nationalId;
  final String email;
  final String phone;
  final String? avatarUrl;
  final String? gender;
  final String? dateOfBirth;
  final String? city;
  final String joinDate;
  final String status;
  final int totalHours;
  final int points;
  final String createdAt;
  final UserStats stats;

  const UserModel({
    required this.id,
    required this.fullName,
    required this.nationalId,
    required this.email,
    required this.phone,
    this.avatarUrl,
    this.gender,
    this.dateOfBirth,
    this.city,
    required this.joinDate,
    required this.status,
    required this.totalHours,
    required this.points,
    required this.createdAt,
    required this.stats,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);
}

@JsonSerializable()
class UserStats {
  final int campaignsCreated;
  final int assignedTasks;
  final int badges;

  const UserStats({
    required this.campaignsCreated,
    required this.assignedTasks,
    required this.badges,
  });

  factory UserStats.fromJson(Map<String, dynamic> json) =>
      _$UserStatsFromJson(json);
}
