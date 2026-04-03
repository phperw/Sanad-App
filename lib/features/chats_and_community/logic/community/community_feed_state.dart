import '../../data/models/post/community_feed_response.dart';

sealed class CommunityFeedState {}

class CommunityFeedInitial extends CommunityFeedState {}

class CommunityFeedLoading extends CommunityFeedState {}

class CommunityFeedSuccess extends CommunityFeedState {
  final List<PostModel> posts;
  final bool hasReachedMax;
  final bool isFetchingMore;

  CommunityFeedSuccess({
    required this.posts,
    this.hasReachedMax = false,
    this.isFetchingMore = false,
  });
}

class CommunityFeedFailure extends CommunityFeedState {
  final String errorMessage;
  CommunityFeedFailure(this.errorMessage);
}
