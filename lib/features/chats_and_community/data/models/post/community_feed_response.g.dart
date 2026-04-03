// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'community_feed_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CommunityFeedResponse _$CommunityFeedResponseFromJson(
  Map<String, dynamic> json,
) => CommunityFeedResponse(
  success: json['success'] as bool,
  message: json['message'] as String,
  pagination: PaginationModel.fromJson(
    json['pagination'] as Map<String, dynamic>,
  ),
  posts: (json['posts'] as List<dynamic>)
      .map((e) => PostModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);


PaginationModel _$PaginationModelFromJson(Map<String, dynamic> json) =>
    PaginationModel(
      page: (json['page'] as num).toInt(),
      limit: (json['limit'] as num).toInt(),
      total: (json['total'] as num).toInt(),
      pages: (json['pages'] as num).toInt(),
    );



PostModel _$PostModelFromJson(Map<String, dynamic> json) => PostModel(
  id: (json['id'] as num).toInt(),
  content: json['content'] as String,
  image: json['image'] as String?,
  createdAt: json['createdAt'] as String,
  updatedAt: json['updatedAt'] as String,
  volunteer: VolunteerModel.fromJson(json['volunteer'] as Map<String, dynamic>),
  stats: StatsModel.fromJson(json['stats'] as Map<String, dynamic>),
  likedByMe: json['likedByMe'] as bool,
);



VolunteerModel _$VolunteerModelFromJson(Map<String, dynamic> json) =>
    VolunteerModel(
      id: (json['id'] as num).toInt(),
      fullName: json['fullName'] as String,
      nationalId: json['nationalId'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      status: json['status'] as String,
    );



StatsModel _$StatsModelFromJson(Map<String, dynamic> json) => StatsModel(
  likes: (json['likes'] as num).toInt(),
  comments: (json['comments'] as num).toInt(),
);


