import 'package:json_annotation/json_annotation.dart';

part 'community_feed_response.g.dart';

@JsonSerializable()
class CommunityFeedResponse {
  final bool success;
  final String message;
  final PaginationModel pagination;
  final List<PostModel> posts;

  CommunityFeedResponse({
    required this.success,
    required this.message,
    required this.pagination,
    required this.posts,
  });

  factory CommunityFeedResponse.fromJson(Map<String, dynamic> json) =>
      _$CommunityFeedResponseFromJson(json);
}

@JsonSerializable()
class PaginationModel {
  final int page;
  final int limit;
  final int total;
  final int pages;

  PaginationModel({
    required this.page,
    required this.limit,
    required this.total,
    required this.pages,
  });

  factory PaginationModel.fromJson(Map<String, dynamic> json) =>
      _$PaginationModelFromJson(json);
}

@JsonSerializable()
class PostModel {
  final int id;
  final String content;
  final String? image;
  final String createdAt;
  final String updatedAt;
  final VolunteerModel volunteer;
  final StatsModel stats;
  final bool likedByMe;

  PostModel({
    required this.id,
    required this.content,
    this.image,
    required this.createdAt,
    required this.updatedAt,
    required this.volunteer,
    required this.stats,
    required this.likedByMe,
  });

  factory PostModel.fromJson(Map<String, dynamic> json) =>
      _$PostModelFromJson(json);
}

@JsonSerializable()
class VolunteerModel {
  final int id;
  final String fullName;
  final String nationalId;
  final String email;
  final String phone;
  final String? avatarUrl;
  final String status;

  VolunteerModel({
    required this.id,
    required this.fullName,
    required this.nationalId,
    required this.email,
    required this.phone,
    this.avatarUrl,
    required this.status,
  });

  factory VolunteerModel.fromJson(Map<String, dynamic> json) =>
      _$VolunteerModelFromJson(json);
}

@JsonSerializable()
class StatsModel {
  final int likes;
  final int comments;

  StatsModel({required this.likes, required this.comments});

  factory StatsModel.fromJson(Map<String, dynamic> json) =>
      _$StatsModelFromJson(json);
}
