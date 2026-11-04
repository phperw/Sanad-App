import 'package:dio/dio.dart';
import 'package:sanad/core/networking/api_constants.dart';
import 'package:sanad/core/networking/api_error_model.dart';
import 'package:sanad/core/networking/api_result.dart';
import 'package:sanad/core/networking/error_hander.dart';

import 'models/nearby_mission.dart';

class NearbyMissionsPage {
  final List<NearbyMission> missions;
  final bool hasMore;

  const NearbyMissionsPage({required this.missions, required this.hasMore});
}

abstract interface class NearbyMissionsRepository {
  Future<ApiResult<NearbyMissionsPage>> getNearbyMissions({
    required double latitude,
    required double longitude,
    required int radiusMeters,
    required int page,
    required int limit,
  });

  Future<ApiResult<bool>> joinMission(int taskId);

  Future<ApiResult<bool>> cancelJoinRequest(int taskId);
}

class DioNearbyMissionsRepository implements NearbyMissionsRepository {
  final Dio _dio;

  const DioNearbyMissionsRepository(this._dio);

  @override
  Future<ApiResult<NearbyMissionsPage>> getNearbyMissions({
    required double latitude,
    required double longitude,
    required int radiusMeters,
    required int page,
    required int limit,
  }) async {
    try {
      final response = await _dio.get(
        '${ApiConstants.endpointMissions}/nearby',
        queryParameters: {
          'latitude': latitude,
          'longitude': longitude,
          'radiusMeters': radiusMeters,
          'page': page,
          'limit': limit,
        },
      );
      final body = _jsonMap(response.data);
      if (body['success'] == false) return Failure(_responseError(body));

      final rawMissions = body['missions'];
      final missions = rawMissions is List
          ? rawMissions
                .map((mission) => NearbyMission.fromJson(_jsonMap(mission)))
                .where((mission) => mission.id > 0)
                .toList()
          : const <NearbyMission>[];

      return Success(
        NearbyMissionsPage(
          missions: missions,
          hasMore: rawMissions is List && rawMissions.length >= limit,
        ),
      );
    } catch (error) {
      return Failure(ErrorHandler.handle(error));
    }
  }

  @override
  Future<ApiResult<bool>> joinMission(int taskId) =>
      _sendJoinRequest(taskId, cancel: false);

  @override
  Future<ApiResult<bool>> cancelJoinRequest(int taskId) =>
      _sendJoinRequest(taskId, cancel: true);

  Future<ApiResult<bool>> _sendJoinRequest(
    int taskId, {
    required bool cancel,
  }) async {
    try {
      final path = '${ApiConstants.endpointMissions}/$taskId/join';
      final response = cancel ? await _dio.delete(path) : await _dio.post(path);
      final body = _jsonMap(response.data);
      if (body['success'] == false) return Failure(_responseError(body));
      return Success(true);
    } catch (error) {
      return Failure(ErrorHandler.handle(error));
    }
  }

  ApiErrorModel _responseError(Map<String, dynamic> body) {
    final message = body['message'] ?? body['error'];
    if (message is String && message.trim().isNotEmpty) {
      return ApiErrorModel(message: message);
    }
    return const ApiErrorModel(message: 'تعذر إكمال الطلب');
  }
}

Map<String, dynamic> _jsonMap(Object? value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return value.map((key, value) => MapEntry('$key', value));
  return const {};
}
