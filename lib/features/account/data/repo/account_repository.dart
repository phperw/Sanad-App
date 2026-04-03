import 'package:dio/dio.dart';
import 'package:sanad/core/networking/api_constants.dart';
import 'package:sanad/core/networking/api_error_model.dart';
import 'package:sanad/core/networking/api_result.dart';
import 'package:sanad/core/networking/error_hander.dart';
import '../models/profile_response.dart';

class AccountRepository {
  final Dio _dio;

  const AccountRepository(this._dio);

  Future<ApiResult<ProfileResponse>> getProfile() async {
    try {
      final response = await _dio.get(ApiConstants.endpointProfile);
      return Success(
        ProfileResponse.fromJson(response.data as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      return Failure(ErrorHandler.handle(e));
    } catch (e) {
      return Failure(ApiErrorModel(message: e.toString()));
    }
  }
}
