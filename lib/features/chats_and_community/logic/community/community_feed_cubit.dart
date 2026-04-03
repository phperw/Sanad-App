import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/post/community_feed_response.dart';
import '../../data/repo/post_repository.dart';
import '../../../../core/networking/api_result.dart';
import 'community_feed_state.dart';

class CommunityFeedCubit extends Cubit<CommunityFeedState> {
  final PostRepository _repository;

  CommunityFeedCubit(this._repository) : super(CommunityFeedInitial());

  // ignore: prefer_final_fields
  List<PostModel> _postsList = [];
  int _currentPage = 1;
  bool _hasReachedMax = false;

  Future<void> getFeed({bool isRefresh = false}) async {
    if (isRefresh) {
      _currentPage = 1;
      _hasReachedMax = false;
      _postsList.clear();
      emit(CommunityFeedLoading());
    } else {
      if (_hasReachedMax ||
          state is CommunityFeedLoading ||
          (state is CommunityFeedSuccess &&
              (state as CommunityFeedSuccess).isFetchingMore)) {
        return;
      }
      emit(
        CommunityFeedSuccess(
          posts: List.from(_postsList),
          isFetchingMore: true,
          hasReachedMax: _hasReachedMax,
        ),
      );
    }

    final result = await _repository.getCommunityFeed(
      page: _currentPage,
      limit: 20,
    );

    switch (result) {
      case Success(:final data):
        _hasReachedMax = data.pagination.page >= data.pagination.pages;
        if (data.posts.isNotEmpty) {
          _currentPage++;
          _postsList.addAll(data.posts);
        }
        emit(
          CommunityFeedSuccess(
            posts: List.from(_postsList),
            hasReachedMax: _hasReachedMax,
            isFetchingMore: false,
          ),
        );
      case Failure(:final error):
        if (_postsList.isEmpty) {
          emit(CommunityFeedFailure(error.message));
        } else {
          emit(
            CommunityFeedSuccess(
              posts: List.from(_postsList),
              hasReachedMax: _hasReachedMax,
              isFetchingMore: false,
            ),
          );
        }
    }
  }
}
