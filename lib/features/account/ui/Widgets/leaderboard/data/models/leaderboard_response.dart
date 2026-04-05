import 'package:json_annotation/json_annotation.dart';

part 'leaderboard_response.g.dart';

@JsonSerializable()
class LeaderboardResponse {
  final bool success;
  final String message;
  final LeaderboardData leaderboard;

  const LeaderboardResponse({
    required this.success,
    required this.message,
    required this.leaderboard,
  });

  factory LeaderboardResponse.fromJson(Map<String, dynamic> json) =>
      _$LeaderboardResponseFromJson(json);
}

@JsonSerializable()
class LeaderboardData {
  final String period;
  final int totalParticipants;
  final int currentUserRank;
  final List<LeaderboardUser> topThree;
  final List<LeaderboardUser> entries;
  final LeaderboardUser currentUser;

  const LeaderboardData({
    required this.period,
    required this.totalParticipants,
    required this.currentUserRank,
    required this.topThree,
    required this.entries,
    required this.currentUser,
  });

  factory LeaderboardData.fromJson(Map<String, dynamic> json) =>
      _$LeaderboardDataFromJson(json);
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
