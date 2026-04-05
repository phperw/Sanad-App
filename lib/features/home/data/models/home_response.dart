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
  @JsonKey(name: 'content')
  final String description;
  @JsonKey(name: 'image')
  final String? imageUrl;
  final bool isPinned;
  final String createdAt;

  const Announcement({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    required this.isPinned,
    required this.createdAt,
  });

  factory Announcement.fromJson(Map<String, dynamic> json) =>
      _$AnnouncementFromJson(json);
}

@JsonSerializable()
class TaskLocation {
  final int id;
  final String name;
  final double latitude;
  final double longitude;
  final String city;
  final String area;

  const TaskLocation({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.city,
    required this.area,
  });

  factory TaskLocation.fromJson(Map<String, dynamic> json) =>
      _$TaskLocationFromJson(json);
}

@JsonSerializable()
class TaskCampaign {
  final int id;
  final String title;
  final String? coverImage;

  const TaskCampaign({
    required this.id,
    required this.title,
    this.coverImage,
  });

  factory TaskCampaign.fromJson(Map<String, dynamic> json) =>
      _$TaskCampaignFromJson(json);
}

@JsonSerializable()
class TaskAssignment {
  final String status;
  final String? checkInTime;

  const TaskAssignment({
    required this.status,
    this.checkInTime,
  });

  factory TaskAssignment.fromJson(Map<String, dynamic> json) =>
      _$TaskAssignmentFromJson(json);
}

@JsonSerializable()
class HomeTask {
  final int id;
  final String title;
  final String? description;
  final String date;
  final String startTime;
  final String endTime;
  final String status;
  final TaskLocation location;
  final TaskCampaign campaign;
  final TaskAssignment assignment;

  const HomeTask({
    required this.id,
    required this.title,
    this.description,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.location,
    required this.campaign,
    required this.assignment,
  });

  factory HomeTask.fromJson(Map<String, dynamic> json) =>
      _$HomeTaskFromJson(json);

  String get displayTime {
    try {
      final parts = startTime.split(':');
      int hour = int.parse(parts[0]);
      final min = parts[1];
      final suffix = hour >= 12 ? 'م' : 'ص';
      if (hour > 12) hour -= 12;
      if (hour == 0) hour = 12;
      return '$hour:$min $suffix';
    } catch (_) {
      return startTime;
    }
  }

  String get remainingTimeLabel {
    try {
      final now = DateTime.now();
      final parts = startTime.split(':');
      final taskStart = DateTime(
        now.year,
        now.month,
        now.day,
        int.parse(parts[0]),
        int.parse(parts[1]),
      );
      final diff = taskStart.difference(now);
      if (diff.isNegative) return 'انتهت';
      if (diff.inMinutes < 60) return 'متبقي ${diff.inMinutes}د';
      return 'متبقي ${diff.inHours}س';
    } catch (_) {
      return '';
    }
  }
}