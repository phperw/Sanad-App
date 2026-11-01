// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_post_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreatePostResponse _$CreatePostResponseFromJson(Map<String, dynamic> json) =>
    CreatePostResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      post: PostModel.fromJson(json['post'] as Map<String, dynamic>),
    );

PostModel _$PostModelFromJson(Map<String, dynamic> json) => PostModel(
  id: (json['id'] as num).toInt(),
  content: json['content'] as String,
  image: json['image'] as String?,
  createdAt: json['createdAt'] as String,
  updatedAt: json['updatedAt'] as String,
  volunteer: PostVolunteer.fromJson(json['volunteer'] as Map<String, dynamic>),
  stats: PostStats.fromJson(json['stats'] as Map<String, dynamic>),
  likedByMe: json['likedByMe'] as bool,
);

PostVolunteer _$PostVolunteerFromJson(Map<String, dynamic> json) =>
    PostVolunteer(
      id: (json['id'] as num).toInt(),
      fullName: json['fullName'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      avatarUrl: json['avatarUrl'] as String?,
      status: json['status'] as String,
    );

PostStats _$PostStatsFromJson(Map<String, dynamic> json) => PostStats(
  likes: (json['likes'] as num).toInt(),
  comments: (json['comments'] as num).toInt(),
);
