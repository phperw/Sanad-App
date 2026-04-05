// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'leaderboard_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LeaderboardResponse _$LeaderboardResponseFromJson(Map<String, dynamic> json) =>
    LeaderboardResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      leaderboard: LeaderboardData.fromJson(
        json['leaderboard'] as Map<String, dynamic>,
      ),
    );

LeaderboardData _$LeaderboardDataFromJson(Map<String, dynamic> json) =>
    LeaderboardData(
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
