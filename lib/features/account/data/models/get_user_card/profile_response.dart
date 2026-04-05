import 'package:json_annotation/json_annotation.dart';

part 'profile_response.g.dart';

// ─── Root ───────────────────────────────────────────────────────────────────

@JsonSerializable()
class ProfileResponse {
  final bool success;
  final String message;
  final ProfileData profile;

  const ProfileResponse({
    required this.success,
    required this.message,
    required this.profile,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) =>
      _$ProfileResponseFromJson(json);
}

// ─── Profile Data ────────────────────────────────────────────────────────────

@JsonSerializable()
class ProfileData {
  final ProfileVolunteer volunteer;
  final ProfileStats stats;
  final ProfileLeaderboard leaderboard;
  final ProfileAchievements achievements;
  final ProfileCertificates certificates;

  const ProfileData({
    required this.volunteer,
    required this.stats,
    required this.leaderboard,
    required this.achievements,
    required this.certificates,
  });

  factory ProfileData.fromJson(Map<String, dynamic> json) =>
      _$ProfileDataFromJson(json);
}

// ─── Volunteer ───────────────────────────────────────────────────────────────

@JsonSerializable()
class ProfileVolunteer {
  final int id;
  final String fullName;
  final String nationalId;
  final String email;
  final String phone;
  final String? avatarUrl;
  final String status;
  final String? statusLabel;
  final String? memberSinceLabel;
  final String joinDate;

  const ProfileVolunteer({
    required this.id,
    required this.fullName,
    required this.nationalId,
    required this.email,
    required this.phone,
    this.avatarUrl,
    required this.status,
    this.statusLabel,
    this.memberSinceLabel,
    required this.joinDate,
  });

  factory ProfileVolunteer.fromJson(Map<String, dynamic> json) =>
      _$ProfileVolunteerFromJson(json);
}

// ─── Stats ───────────────────────────────────────────────────────────────────

@JsonSerializable()
class ProfileStats {
  final int totalHours;
  final int points;
  final int campaignsCompleted;
  final int badgesCount;
  final int certificatesCount;

  const ProfileStats({
    required this.totalHours,
    required this.points,
    required this.campaignsCompleted,
    required this.badgesCount,
    required this.certificatesCount,
  });

  factory ProfileStats.fromJson(Map<String, dynamic> json) =>
      _$ProfileStatsFromJson(json);
}

// ─── Leaderboard ─────────────────────────────────────────────────────────────

@JsonSerializable()
class ProfileLeaderboard {
  final String period;
  final int totalParticipants;
  final int currentUserRank;
  final List<LeaderboardUser> topThree;
  final List<LeaderboardUser> entries;
  final LeaderboardUser currentUser;

  const ProfileLeaderboard({
    required this.period,
    required this.totalParticipants,
    required this.currentUserRank,
    required this.topThree,
    required this.entries,
    required this.currentUser,
  });

  factory ProfileLeaderboard.fromJson(Map<String, dynamic> json) =>
      _$ProfileLeaderboardFromJson(json);
}

@JsonSerializable()
class LeaderboardUser {
  final int rank;
  final int id;
  final String fullName;
  final String? avatarUrl;
  final bool isCurrentUser;
  final String status;
  final int points;
  final int totalHours;
  final int completedCampaigns;
  final int reportsCount;

  const LeaderboardUser({
    required this.rank,
    required this.id,
    required this.fullName,
    this.avatarUrl,
    required this.isCurrentUser,
    required this.status,
    required this.points,
    required this.totalHours,
    required this.completedCampaigns,
    required this.reportsCount,
  });

  factory LeaderboardUser.fromJson(Map<String, dynamic> json) =>
      _$LeaderboardUserFromJson(json);
}

// ─── Achievements ────────────────────────────────────────────────────────────

@JsonSerializable()
class ProfileAchievements {
  final int achievedCount;
  final int totalCount;
  final List<AchievementItem> items;

  const ProfileAchievements({
    required this.achievedCount,
    required this.totalCount,
    required this.items,
  });

  factory ProfileAchievements.fromJson(Map<String, dynamic> json) =>
      _$ProfileAchievementsFromJson(json);
}

@JsonSerializable()
class AchievementItem {
  final String key;
  final String title;
  final String icon;
  final String color;
  final bool unlocked;
  final String progressLabel;
  final String description;
  final List<String> requirements;

  const AchievementItem({
    required this.key,
    required this.title,
    required this.icon,
    required this.color,
    required this.unlocked,
    required this.progressLabel,
    required this.description,
    required this.requirements,
  });

  factory AchievementItem.fromJson(Map<String, dynamic> json) =>
      _$AchievementItemFromJson(json);
}

// ─── Certificates ────────────────────────────────────────────────────────────

@JsonSerializable()
class ProfileCertificates {
  final int count;
  final List<CertificateItem> items;

  const ProfileCertificates({required this.count, required this.items});

  factory ProfileCertificates.fromJson(Map<String, dynamic> json) =>
      _$ProfileCertificatesFromJson(json);
}

@JsonSerializable()
class CertificateItem {
  final String id;
  final String title;
  final String date;
  final String subtitle;
  final String icon;

  const CertificateItem({
    required this.id,
    required this.title,
    required this.date,
    required this.subtitle,
    required this.icon,
  });

  factory CertificateItem.fromJson(Map<String, dynamic> json) =>
      _$CertificateItemFromJson(json);
}
