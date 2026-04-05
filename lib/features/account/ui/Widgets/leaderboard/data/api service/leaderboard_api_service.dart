import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:sanad/core/networking/api_constants.dart';
import '../models/leaderboard_response.dart';

part 'leaderboard_api_service.g.dart';

@RestApi()
abstract class LeaderboardApiService {
  factory LeaderboardApiService(Dio dio, {String baseUrl}) =
      _LeaderboardApiService;

  @GET(ApiConstants.endpointWeeklyLeaderboard)
  Future<LeaderboardResponse> getWeeklyLeaderboard();

  @GET(ApiConstants.endpointMonthlyLeaderboard)
  Future<LeaderboardResponse> getMonthlyLeaderboard();

  @GET(ApiConstants.endpointAllTimeLeaderboard)
  Future<LeaderboardResponse> getAllTimeLeaderboard();
}
