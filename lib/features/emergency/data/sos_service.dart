import 'package:dio/dio.dart';

class SosService {
  final Dio _dio;
  SosService(this._dio);

  Future<void> sendSosRequest({
    required double latitude,
    required double longitude,
  }) async {
    await _dio.post(
      '/sos-requests',
      data: {'latitude': latitude, 'longitude': longitude},
    );
  }
}
