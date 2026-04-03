import '../../../../core/networking/api_result.dart';
import '../../../../core/networking/error_hander.dart';
import '../models/create_post_request.dart';
import '../models/create_post_response.dart';
import '../api_service/post_api_service.dart';
import '../models/post/community_feed_response.dart';

class PostRepository {
  final PostApiService _apiService;

  PostRepository(this._apiService);

  Future<ApiResult<CreatePostResponse>> createPost(
    CreatePostRequest request,
  ) async {
    try {
      final response = await _apiService.createPost(request);
      return Success(response);
    } catch (e) {
      return Failure(ErrorHandler.handle(e));
    }
  }

  Future<ApiResult<CommunityFeedResponse>> getCommunityFeed({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _apiService.getCommunityFeed(page, limit);
      return Success(response);
    } catch (e) {
      return Failure(ErrorHandler.handle(e));
    }
  }
}
