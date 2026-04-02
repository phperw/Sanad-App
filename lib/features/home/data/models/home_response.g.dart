// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeResponse _$HomeResponseFromJson(Map<String, dynamic> json) => HomeResponse(
  success: json['success'] as bool,
  message: json['message'] as String,
  summary: HomeSummary.fromJson(json['summary'] as Map<String, dynamic>),
);

HomeSummary _$HomeSummaryFromJson(Map<String, dynamic> json) => HomeSummary(
  volunteer: Volunteer.fromJson(json['volunteer'] as Map<String, dynamic>),
  stats: Stats.fromJson(json['stats'] as Map<String, dynamic>),
  announcements: (json['announcements'] as List<dynamic>)
      .map((e) => Announcement.fromJson(e as Map<String, dynamic>))
      .toList(),
  todayTasks: (json['todayTasks'] as List<dynamic>)
      .map((e) => HomeTask.fromJson(e as Map<String, dynamic>))
      .toList(),
  upcomingTasks: (json['upcomingTasks'] as List<dynamic>)
      .map((e) => HomeTask.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Volunteer _$VolunteerFromJson(Map<String, dynamic> json) => Volunteer(
  id: (json['id'] as num).toInt(),
  fullName: json['fullName'] as String,
  nationalId: json['nationalId'] as String,
  email: json['email'] as String,
  phone: json['phone'] as String,
  avatarUrl: json['avatarUrl'] as String?,
  status: json['status'] as String,
  totalHours: (json['totalHours'] as num).toInt(),
  points: (json['points'] as num).toInt(),
);

Stats _$StatsFromJson(Map<String, dynamic> json) => Stats(
  totalHours: (json['totalHours'] as num).toInt(),
  points: (json['points'] as num).toInt(),
  badges: (json['badges'] as num).toInt(),
  assignedTasks: (json['assignedTasks'] as num).toInt(),
  reports: (json['reports'] as num).toInt(),
  todayTasks: (json['todayTasks'] as num).toInt(),
);

Announcement _$AnnouncementFromJson(Map<String, dynamic> json) => Announcement(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  description: json['description'] as String,
  imageUrl: json['imageUrl'] as String?,
);

HomeTask _$HomeTaskFromJson(Map<String, dynamic> json) => HomeTask(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  time: json['time'] as String,
  locationName: json['locationName'] as String,
  taskType: json['taskType'] as String,
  remainingTime: json['remainingTime'] as String,
);
