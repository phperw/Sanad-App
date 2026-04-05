import '../data/models/create_post_response.dart';

sealed class CreatePostState {}

final class CreatePostInitial extends CreatePostState {}

final class CreatePostLoading extends CreatePostState {}

final class CreatePostSuccess extends CreatePostState {
  final CreatePostResponse response;
  CreatePostSuccess(this.response);
}

final class CreatePostFailure extends CreatePostState {
  final String errorMessage;
  CreatePostFailure(this.errorMessage);
}
