import 'package:dio/dio.dart';
import 'package:sanad/core/networking/api_constants.dart';
import 'package:sanad/core/networking/api_result.dart';
import 'package:sanad/core/networking/error_hander.dart';
import '../../models/get_user_card/profile_response.dart';

class AccountRepository {
  final Dio _dio;

  AccountRepository(this._dio);

  Future<ApiResult<ProfileResponse>> getProfile() async {
    try {
      final response = await _dio.get(ApiConstants.endpointGetallProfiles);
      return Success(ProfileResponse.fromJson(response.data));
    } catch (error) {
      return Failure(ErrorHandler.handle(error));
    }
  }
}
