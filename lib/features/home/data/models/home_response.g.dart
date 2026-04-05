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

Map<String, dynamic> _$HomeResponseToJson(HomeResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'summary': instance.summary,
    };

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

Map<String, dynamic> _$HomeSummaryToJson(HomeSummary instance) =>
    <String, dynamic>{
      'volunteer': instance.volunteer,
      'stats': instance.stats,
      'announcements': instance.announcements,
      'todayTasks': instance.todayTasks,
      'upcomingTasks': instance.upcomingTasks,
    };

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

Map<String, dynamic> _$VolunteerToJson(Volunteer instance) => <String, dynamic>{
  'id': instance.id,
  'fullName': instance.fullName,
  'nationalId': instance.nationalId,
  'email': instance.email,
  'phone': instance.phone,
  'avatarUrl': instance.avatarUrl,
  'status': instance.status,
  'totalHours': instance.totalHours,
  'points': instance.points,
};

Stats _$StatsFromJson(Map<String, dynamic> json) => Stats(
  totalHours: (json['totalHours'] as num).toInt(),
  points: (json['points'] as num).toInt(),
  badges: (json['badges'] as num).toInt(),
  assignedTasks: (json['assignedTasks'] as num).toInt(),
  reports: (json['reports'] as num).toInt(),
  todayTasks: (json['todayTasks'] as num).toInt(),
);

Map<String, dynamic> _$StatsToJson(Stats instance) => <String, dynamic>{
  'totalHours': instance.totalHours,
  'points': instance.points,
  'badges': instance.badges,
  'assignedTasks': instance.assignedTasks,
  'reports': instance.reports,
  'todayTasks': instance.todayTasks,
};

Announcement _$AnnouncementFromJson(Map<String, dynamic> json) => Announcement(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  description: json['content'] as String,
  imageUrl: json['image'] as String?,
  isPinned: json['isPinned'] as bool,
  createdAt: json['createdAt'] as String,
);

Map<String, dynamic> _$AnnouncementToJson(Announcement instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.description,
      'image': instance.imageUrl,
      'isPinned': instance.isPinned,
      'createdAt': instance.createdAt,
    };

TaskLocation _$TaskLocationFromJson(Map<String, dynamic> json) => TaskLocation(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
  city: json['city'] as String,
  area: json['area'] as String,
);

Map<String, dynamic> _$TaskLocationToJson(TaskLocation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'city': instance.city,
      'area': instance.area,
    };

TaskCampaign _$TaskCampaignFromJson(Map<String, dynamic> json) => TaskCampaign(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  coverImage: json['coverImage'] as String?,
);

Map<String, dynamic> _$TaskCampaignToJson(TaskCampaign instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'coverImage': instance.coverImage,
    };

TaskAssignment _$TaskAssignmentFromJson(Map<String, dynamic> json) =>
    TaskAssignment(
      status: json['status'] as String,
      checkInTime: json['checkInTime'] as String?,
    );

Map<String, dynamic> _$TaskAssignmentToJson(TaskAssignment instance) =>
    <String, dynamic>{
      'status': instance.status,
      'checkInTime': instance.checkInTime,
    };

HomeTask _$HomeTaskFromJson(Map<String, dynamic> json) => HomeTask(
  id: (json['id'] as num).toInt(),
  title: json['title'] as String,
  description: json['description'] as String?,
  date: json['date'] as String,
  startTime: json['startTime'] as String,
  endTime: json['endTime'] as String,
  status: json['status'] as String,
  location: TaskLocation.fromJson(json['location'] as Map<String, dynamic>),
  campaign: TaskCampaign.fromJson(json['campaign'] as Map<String, dynamic>),
  assignment: TaskAssignment.fromJson(
    json['assignment'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$HomeTaskToJson(HomeTask instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'description': instance.description,
  'date': instance.date,
  'startTime': instance.startTime,
  'endTime': instance.endTime,
  'status': instance.status,
  'location': instance.location,
  'campaign': instance.campaign,
  'assignment': instance.assignment,
};
