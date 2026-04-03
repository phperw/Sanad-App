import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/models/create_post_request.dart';
import '../data/models/create_post_response.dart';
import '../data/repo/post_repository.dart';
import '../../../../core/networking/api_result.dart';
part 'create_post_state.dart';

class CreatePostCubit extends Cubit<CreatePostState> {
  final PostRepository _repository;

  CreatePostCubit(this._repository) : super(CreatePostInitial());

  Future<void> createPost({required String content, String? imageUrl}) async {
    emit(CreatePostLoading());

    final request = CreatePostRequest(content: content, image: imageUrl);
    final result = await _repository.createPost(request);

    switch (result) {
      case Success<CreatePostResponse>():
        emit(CreatePostSuccess(result.data));
      case Failure<CreatePostResponse>():
        emit(CreatePostFailure(result.error.message));
    }
  }
}
