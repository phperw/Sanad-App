import 'package:dio/dio.dart';
import 'package:sanad/core/networking/api_result.dart';
import 'package:sanad/core/networking/error_hander.dart';
import 'package:sanad/core/networking/api_error_model.dart';
import 'package:sanad/core/networking/api_constants.dart';
import '../../models/leaderboard_response.dart';

class MonthlyLeaderboardRepository {
  final Dio _dio;

  const MonthlyLeaderboardRepository(this._dio);

  Future<ApiResult<LeaderboardResponse>> getMonthlyLeaderboard() async {
    try {
      final response = await _dio.get(ApiConstants.endpointMonthlyLeaderboard);
      return Success(LeaderboardResponse.fromJson(response.data));
    } on DioException catch (e) {
      return Failure(ErrorHandler.handle(e));
    } catch (e) {
      return Failure(ApiErrorModel(message: e.toString()));
    }
  }
}
