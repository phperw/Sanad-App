import 'package:json_annotation/json_annotation.dart';

part 'home_response.g.dart';

@JsonSerializable()
class HomeResponse {
  final bool success;
  final String message;
  final HomeSummary summary;

  const HomeResponse({
    required this.success,
    required this.message,
    required this.summary,
  });

  factory HomeResponse.fromJson(Map<String, dynamic> json) =>
      _$HomeResponseFromJson(json);
}

@JsonSerializable()
class HomeSummary {
  final Volunteer volunteer;
  final Stats stats;
  final List<Announcement> announcements;
  final List<HomeTask> todayTasks;
  final List<HomeTask> upcomingTasks;

  const HomeSummary({
    required this.volunteer,
    required this.stats,
    required this.announcements,
    required this.todayTasks,
    required this.upcomingTasks,
  });

  factory HomeSummary.fromJson(Map<String, dynamic> json) =>
      _$HomeSummaryFromJson(json);
}

@JsonSerializable()
class Volunteer {
  final int id;
  final String fullName;
  final String nationalId;
  final String email;
  final String phone;
  final String? avatarUrl;
  final String status;
  final int totalHours;
  final int points;

  const Volunteer({
    required this.id,
    required this.fullName,
    required this.nationalId,
    required this.email,
    required this.phone,
    this.avatarUrl,
    required this.status,
    required this.totalHours,
    required this.points,
  });

  factory Volunteer.fromJson(Map<String, dynamic> json) =>
      _$VolunteerFromJson(json);
}

@JsonSerializable()
class Stats {
  final int totalHours;
  final int points;
  final int badges;
  final int assignedTasks;
  final int reports;
  final int todayTasks;

  const Stats({
    required this.totalHours,
    required this.points,
    required this.badges,
    required this.assignedTasks,
    required this.reports,
    required this.todayTasks,
  });

  factory Stats.fromJson(Map<String, dynamic> json) => _$StatsFromJson(json);
}

@JsonSerializable()
class Announcement {
  final int id;
  final String title;
  final String description;
  final String? imageUrl;

  const Announcement({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
  });

  factory Announcement.fromJson(Map<String, dynamic> json) =>
      _$AnnouncementFromJson(json);
}

@JsonSerializable()
class HomeTask {
  final int id;
  final String title;
  final String time;
  final String locationName;
  final String taskType;
  final String remainingTime;

  const HomeTask({
    required this.id,
    required this.title,
    required this.time,
    required this.locationName,
    required this.taskType,
    required this.remainingTime,
  });

  factory HomeTask.fromJson(Map<String, dynamic> json) =>
      _$HomeTaskFromJson(json);
}
