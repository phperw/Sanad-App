// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) =>
    LoginResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
    );

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  id: (json['id'] as num).toInt(),
  fullName: json['fullName'] as String,
  nationalId: json['nationalId'] as String,
  email: json['email'] as String,
  phone: json['phone'] as String,
  avatarUrl: json['avatarUrl'] as String?,
  gender: json['gender'] as String?,
  dateOfBirth: json['dateOfBirth'] as String?,
  city: json['city'] as String?,
  joinDate: json['joinDate'] as String,
  status: json['status'] as String,
  totalHours: (json['totalHours'] as num).toInt(),
  points: (json['points'] as num).toInt(),
  createdAt: json['createdAt'] as String,
  stats: UserStats.fromJson(json['stats'] as Map<String, dynamic>),
);

UserStats _$UserStatsFromJson(Map<String, dynamic> json) => UserStats(
  campaignsCreated: (json['campaignsCreated'] as num).toInt(),
  assignedTasks: (json['assignedTasks'] as num).toInt(),
  badges: (json['badges'] as num).toInt(),
);
