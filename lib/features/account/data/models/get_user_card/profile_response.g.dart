// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileResponse _$ProfileResponseFromJson(Map<String, dynamic> json) =>
    ProfileResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      profile: ProfileData.fromJson(json['profile'] as Map<String, dynamic>),
    );

ProfileData _$ProfileDataFromJson(Map<String, dynamic> json) => ProfileData(
  volunteer: ProfileVolunteer.fromJson(
    json['volunteer'] as Map<String, dynamic>,
  ),
  stats: ProfileStats.fromJson(json['stats'] as Map<String, dynamic>),
  leaderboard: ProfileLeaderboard.fromJson(
    json['leaderboard'] as Map<String, dynamic>,
  ),
  achievements: ProfileAchievements.fromJson(
    json['achievements'] as Map<String, dynamic>,
  ),
  certificates: ProfileCertificates.fromJson(
    json['certificates'] as Map<String, dynamic>,
  ),
);

ProfileVolunteer _$ProfileVolunteerFromJson(Map<String, dynamic> json) =>
    ProfileVolunteer(
      id: (json['id'] as num).toInt(),
      fullName: json['fullName'] as String,
      nationalId: json['nationalId'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      status: json['status'] as String,
      statusLabel: json['statusLabel'] as String?,
      memberSinceLabel: json['memberSinceLabel'] as String?,
      joinDate: json['joinDate'] as String,
    );

ProfileStats _$ProfileStatsFromJson(Map<String, dynamic> json) => ProfileStats(
  totalHours: (json['totalHours'] as num).toInt(),
  points: (json['points'] as num).toInt(),
  campaignsCompleted: (json['campaignsCompleted'] as num).toInt(),
  badgesCount: (json['badgesCount'] as num).toInt(),
  certificatesCount: (json['certificatesCount'] as num).toInt(),
);

ProfileLeaderboard _$ProfileLeaderboardFromJson(Map<String, dynamic> json) =>
    ProfileLeaderboard(
      period: json['period'] as String,
      totalParticipants: (json['totalParticipants'] as num).toInt(),
      currentUserRank: (json['currentUserRank'] as num).toInt(),
      topThree: (json['topThree'] as List<dynamic>)
          .map((e) => LeaderboardUser.fromJson(e as Map<String, dynamic>))
          .toList(),
      entries: (json['entries'] as List<dynamic>)
          .map((e) => LeaderboardUser.fromJson(e as Map<String, dynamic>))
          .toList(),
      currentUser: LeaderboardUser.fromJson(
        json['currentUser'] as Map<String, dynamic>,
      ),
    );

LeaderboardUser _$LeaderboardUserFromJson(Map<String, dynamic> json) =>
    LeaderboardUser(
      rank: (json['rank'] as num).toInt(),
      id: (json['id'] as num).toInt(),
      fullName: json['fullName'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      isCurrentUser: json['isCurrentUser'] as bool,
      status: json['status'] as String,
      points: (json['points'] as num).toInt(),
      totalHours: (json['totalHours'] as num).toInt(),
      completedCampaigns: (json['completedCampaigns'] as num).toInt(),
      reportsCount: (json['reportsCount'] as num).toInt(),
    );

ProfileAchievements _$ProfileAchievementsFromJson(Map<String, dynamic> json) =>
    ProfileAchievements(
      achievedCount: (json['achievedCount'] as num).toInt(),
      totalCount: (json['totalCount'] as num).toInt(),
      items: (json['items'] as List<dynamic>)
          .map((e) => AchievementItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

AchievementItem _$AchievementItemFromJson(Map<String, dynamic> json) =>
    AchievementItem(
      key: json['key'] as String,
      title: json['title'] as String,
      icon: json['icon'] as String,
      color: json['color'] as String,
      unlocked: json['unlocked'] as bool,
      progressLabel: json['progressLabel'] as String,
      description: json['description'] as String,
      requirements: (json['requirements'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
    );

ProfileCertificates _$ProfileCertificatesFromJson(Map<String, dynamic> json) =>
    ProfileCertificates(
      count: (json['count'] as num).toInt(),
      items: (json['items'] as List<dynamic>)
          .map((e) => CertificateItem.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

CertificateItem _$CertificateItemFromJson(Map<String, dynamic> json) =>
    CertificateItem(
      id: json['id'] as String,
      title: json['title'] as String,
      date: json['date'] as String,
      subtitle: json['subtitle'] as String,
      icon: json['icon'] as String,
    );
