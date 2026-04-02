import 'package:dio/dio.dart';
import 'package:sanad/core/networking/api_constants.dart';
import 'package:sanad/core/networking/api_error_model.dart';
import 'package:sanad/core/networking/api_result.dart';
import '../../../../../core/networking/error_hander.dart';
import '../models/login_request.dart';
import '../models/login_response.dart';

class LoginRepository {
  final Dio _dio;

  const LoginRepository(this._dio);

  Future<ApiResult<LoginResponse>> login(LoginRequest request) async {
    try {
      final response = await _dio.post(
        ApiConstants.login,
        data: request.toJson(),
      );
      return Success(
        LoginResponse.fromJson(response.data as Map<String, dynamic>),
      );
    } on DioException catch (e) {
      return Failure(ErrorHandler.handle(e));
    } catch (e) {
      return Failure(ApiErrorModel(message: e.toString()));
    }
  }
}
