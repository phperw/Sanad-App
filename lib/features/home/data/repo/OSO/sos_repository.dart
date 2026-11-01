import 'package:dio/dio.dart';
import 'package:sanad/core/networking/api_constants.dart';
import 'package:sanad/core/networking/api_result.dart';
import 'package:sanad/core/networking/error_hander.dart';
import '../../models/OSO/sos_request_model.dart';

class SosRepository {
  final Dio _dio;

  const SosRepository(this._dio);

  static const String _base = ApiConstants.endpointSosSend;

  Future<ApiResult<SosRequestModel>> sendSos({
    required double latitude,
    required double longitude,
  }) async {
    try {
      final response = await _dio.post(
        _base,
        data: {'latitude': latitude, 'longitude': longitude},
      );
      final data = response.data as Map<String, dynamic>;
      return Success(
        SosRequestModel.fromJson(data['request'] as Map<String, dynamic>),
      );
    } catch (error) {
      return Failure(ErrorHandler.handle(error));
    }
  }

  Future<ApiResult<SosRequestModel?>> getActive() async {
    try {
      final response = await _dio.get('$_base/active');
      final data = response.data as Map<String, dynamic>;
      final raw = data['activeRequest'];
      if (raw == null) return Success(null);
      return Success(SosRequestModel.fromJson(raw as Map<String, dynamic>));
    } catch (error) {
      return Failure(ErrorHandler.handle(error));
    }
  }

  Future<ApiResult<SosRequestModel>> getById(int id) async {
    try {
      final response = await _dio.get('$_base/$id');
      final data = response.data as Map<String, dynamic>;
      return Success(
        SosRequestModel.fromJson(data['request'] as Map<String, dynamic>),
      );
    } catch (error) {
      return Failure(ErrorHandler.handle(error));
    }
  }

  Future<ApiResult<SosRequestModel>> updateLocation({
    required int id,
    required double latitude,
    required double longitude,
  }) async {
    try {
      final response = await _dio.patch(
        '$_base/$id/location',
        data: {'latitude': latitude, 'longitude': longitude},
      );
      final data = response.data as Map<String, dynamic>;
      return Success(
        SosRequestModel.fromJson(data['request'] as Map<String, dynamic>),
      );
    } catch (error) {
      return Failure(ErrorHandler.handle(error));
    }
  }

  Future<ApiResult<bool>> cancel() async {
    try {
      await _dio.patch(ApiConstants.endpointSosCancel);
      return Success(true);
    } catch (error) {
      return Failure(ErrorHandler.handle(error));
    }
  }
}