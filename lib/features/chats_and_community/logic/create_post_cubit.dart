import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/networking/api_result.dart';
import '../data/repo/post_repository.dart';
import 'create_post_state.dart';

class CreatePostCubit extends Cubit<CreatePostState> {
  final PostRepository _repository;

  CreatePostCubit(this._repository) : super(CreatePostInitial());

  Future<void> createPost({required String content, File? image}) async {
    emit(CreatePostLoading());

    final result = await _repository.createPost(content: content, image: image);

    switch (result) {
      case Success(:final data):
        emit(CreatePostSuccess(data));
      case Failure(:final error):
        emit(CreatePostFailure(error.message));
    }
  }
}
