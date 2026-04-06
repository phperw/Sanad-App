import 'package:sanad/core/networking/api_result.dart';
import '../../../../../core/networking/error_hander.dart';
import '../../OSO_api_service/sos_api_service.dart';
import '../../models/OSO/sos_request_body.dart';
import '../../models/OSO/sos_response.dart';

class SosRepository {
  final SosApiService _sosApiService;

  SosRepository(this._sosApiService);

  Future<ApiResult<SosResponse>> sendSos({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final response = await _sosApiService.sendSos(
        SosSendRequestBody(latitude: latitude, longitude: longitude),
      );
      return Success(response);
    } catch (error) {
      return Failure(ErrorHandler.handle(error));
    }
  }

  Future<ApiResult<SosResponse>> cancelSos() async {
    try {
      final response = await _sosApiService.cancelSos();
      return Success(response);
    } catch (error) {
      return Failure(ErrorHandler.handle(error));
    }
  }
}