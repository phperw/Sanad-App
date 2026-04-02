import 'package:dio/dio.dart';
import 'package:sanad/core/networking/api_constants.dart';
import 'package:sanad/core/networking/api_result.dart';
import 'package:sanad/core/networking/error_hander.dart';
import '../models/home_response.dart';

class HomeRepository {
  final Dio _dio;

  HomeRepository(this._dio);

  Future<ApiResult<HomeResponse>> getHomeData() async {
    try {
      final response = await _dio.get(ApiConstants.endpointHome);
      return Success(HomeResponse.fromJson(response.data));
    } catch (error) {
      return Failure(ErrorHandler.handle(error));
    }
  }
}
