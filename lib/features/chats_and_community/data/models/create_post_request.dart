import 'package:json_annotation/json_annotation.dart';
part 'create_post_request.g.dart';

@JsonSerializable()
class CreatePostRequest {
  final String content;
  final String? image;

  const CreatePostRequest({required this.content, this.image});

  Map<String, dynamic> toJson() => _$CreatePostRequestToJson(this);
}
