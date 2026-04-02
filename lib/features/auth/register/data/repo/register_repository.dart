import 'package:dio/dio.dart';
import 'package:sanad/core/networking/api_result.dart';
import 'package:sanad/core/networking/api_constants.dart';
import 'package:sanad/core/networking/error_hander.dart';

import '../model/register_request.dart';
import '../model/register_response.dart';

class RegisterRepository {
  final Dio _dio;

  RegisterRepository(this._dio);

  Future<ApiResult<RegisterResponse>> register(RegisterRequest request) async {
    try {
      final response = await _dio.post(
        ApiConstants.register,
        data: request.toJson(),
      );
      return Success(RegisterResponse.fromJson(response.data));
    } catch (error) {
      return Failure(ErrorHandler.handle(error));
    }
  }
}
