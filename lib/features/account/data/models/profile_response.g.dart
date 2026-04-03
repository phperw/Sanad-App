part of 'profile_response.dart';

ProfileResponse _$ProfileResponseFromJson(Map<String, dynamic> json) =>
    ProfileResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      user: ProfileUser.fromJson(json['user'] as Map<String, dynamic>),
    );

ProfileUser _$ProfileUserFromJson(Map<String, dynamic> json) => ProfileUser(
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
      stats: ProfileStats.fromJson(json['stats'] as Map<String, dynamic>),
    );

ProfileStats _$ProfileStatsFromJson(Map<String, dynamic> json) => ProfileStats(
      campaignsCreated: (json['campaignsCreated'] as num).toInt(),
      assignedTasks: (json['assignedTasks'] as num).toInt(),
      badges: (json['badges'] as num).toInt(),
    );
