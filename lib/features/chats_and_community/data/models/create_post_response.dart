import 'package:json_annotation/json_annotation.dart';
part 'create_post_response.g.dart';

@JsonSerializable()
class CreatePostResponse {
  final bool success;
  final String message;
  final PostModel post;

  const CreatePostResponse({
    required this.success,
    required this.message,
    required this.post,
  });

  factory CreatePostResponse.fromJson(Map<String, dynamic> json) =>
      _$CreatePostResponseFromJson(json);
}

@JsonSerializable()
class PostModel {
  final int id;
  final String content;
  final String? image;
  final String createdAt;
  final String updatedAt;
  final PostVolunteer volunteer;
  final PostStats stats;
  final bool likedByMe;

  const PostModel({
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
class PostVolunteer {
  final int id;
  final String fullName;
  final String email;
  final String phone;
  final String? avatarUrl;
  final String status;

  const PostVolunteer({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    this.avatarUrl,
    required this.status,
  });

  factory PostVolunteer.fromJson(Map<String, dynamic> json) =>
      _$PostVolunteerFromJson(json);
}

@JsonSerializable()
class PostStats {
  final int likes;
  final int comments;

  const PostStats({required this.likes, required this.comments});

  factory PostStats.fromJson(Map<String, dynamic> json) =>
      _$PostStatsFromJson(json);
}
