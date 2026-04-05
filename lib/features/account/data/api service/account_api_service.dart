import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:sanad/core/networking/api_constants.dart';
import '../models/profile_response.dart';

part 'account_api_service.g.dart';

@RestApi()
abstract class AccountApiService {
  factory AccountApiService(Dio dio, {String baseUrl}) = _AccountApiService;

  @GET(ApiConstants.endpointGetallProfiles)
  Future<ProfileResponse> getProfile();
}
