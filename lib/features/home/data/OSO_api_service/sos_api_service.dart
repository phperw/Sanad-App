import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../core/networking/api_constants.dart';
import '../models/OSO/sos_request_body.dart';
import '../models/OSO/sos_response.dart';
part 'sos_api_service.g.dart';

@RestApi(baseUrl: ApiConstants.baseURL)
abstract class SosApiService {
  factory SosApiService(Dio dio, {String baseUrl}) = _SosApiService;

  @POST(ApiConstants.endpointSosSend)
  Future<SosResponse> sendSos(@Body() SosSendRequestBody body);

  @PATCH(ApiConstants.endpointSosCancel)
  Future<SosResponse> cancelSos();
}