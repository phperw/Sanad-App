import 'package:dio/dio.dart';
import 'package:sanad/core/networking/api_result.dart';
import 'package:sanad/core/networking/error_hander.dart';
import 'package:sanad/core/networking/api_error_model.dart';
import 'package:sanad/core/networking/api_constants.dart';
import '../../models/leaderboard_response.dart';

class AllTimeLeaderboardRepository {
  final Dio _dio;

  const AllTimeLeaderboardRepository(this._dio);

  Future<ApiResult<LeaderboardResponse>> getAllTimeLeaderboard() async {
    try {
      final response = await _dio.get(ApiConstants.endpointAllTimeLeaderboard);
      return Success(LeaderboardResponse.fromJson(response.data));
    } on DioException catch (e) {
      return Failure(ErrorHandler.handle(e));
    } catch (e) {
      return Failure(ApiErrorModel(message: e.toString()));
    }
  }
}
