import 'package:json_annotation/json_annotation.dart';

part 'profile_response.g.dart';

@JsonSerializable()
class ProfileResponse {
  final bool success;
  final String message;
  final ProfileUser user;

  const ProfileResponse({
    required this.success,
    required this.message,
    required this.user,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) =>
      _$ProfileResponseFromJson(json);
}

@JsonSerializable()
class ProfileUser {
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
  final ProfileStats stats;

  const ProfileUser({
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

  factory ProfileUser.fromJson(Map<String, dynamic> json) =>
      _$ProfileUserFromJson(json);

  String get formattedJoinDate {
    try {
      final date = DateTime.parse(joinDate);
      const months = [
        '', 'يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو',
        'يوليو', 'أغسطس', 'سبتمبر', 'أكتوبر', 'نوفمبر', 'ديسمبر',
      ];
      return 'عضو منذ ${months[date.month]} ${date.year}';
    } catch (_) {
      return 'عضو منذ وقت قريب';
    }
  }
}

@JsonSerializable()
class ProfileStats {
  final int campaignsCreated;
  final int assignedTasks;
  final int badges;

  const ProfileStats({
    required this.campaignsCreated,
    required this.assignedTasks,
    required this.badges,
  });

  factory ProfileStats.fromJson(Map<String, dynamic> json) =>
      _$ProfileStatsFromJson(json);
}