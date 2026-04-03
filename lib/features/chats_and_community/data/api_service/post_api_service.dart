import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../core/networking/api_constants.dart';
import '../models/create_post_request.dart';
import '../models/create_post_response.dart';
import '../models/post/community_feed_response.dart';
part 'post_api_service.g.dart';

@RestApi(baseUrl: ApiConstants.baseURL)
abstract class PostApiService {
  factory PostApiService(Dio dio, {String baseUrl}) = _PostApiService;

  @POST(ApiConstants.endpointCreateCommunityPost)
  Future<CreatePostResponse> createPost(@Body() CreatePostRequest request);
  @GET(ApiConstants.endpointCommunityFeed)
  Future<CommunityFeedResponse> getCommunityFeed(
    @Query('page') int page,
    @Query('limit') int limit,
  );
}
