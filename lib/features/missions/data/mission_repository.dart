import 'package:dio/dio.dart';
import 'package:sanad/core/networking/api_constants.dart';
import 'package:sanad/core/networking/api_error_model.dart';
import 'package:sanad/core/networking/api_result.dart';
import 'package:sanad/core/networking/error_hander.dart';

import 'models/mission_details.dart';

class MissionRepository {
  final Dio _dio;

  MissionRepository(this._dio);

  Future<ApiResult<MissionDetails>> getMissionDetails(int missionId) async {
    try {
      final response = await _dio.get(
        '${ApiConstants.endpointMissions}/$missionId',
      );
      final body = missionJsonMap(response.data);
      if (body['success'] == false) {
        return Failure(_responseError(body));
      }
      final mission = missionJsonMap(body['mission']);
      if (mission.isEmpty) {
        return Failure(
          const ApiErrorModel(message: 'لم يتم العثور على تفاصيل المهمة'),
        );
      }
      return Success(MissionDetails.fromJson(mission));
    } catch (error) {
      return Failure(ErrorHandler.handle(error));
    }
  }

  Future<ApiResult<String>> uploadMissionImage(String dataUri) async {
    try {
      final response = await _dio.post(
        ApiConstants.endpointMissionImageUpload,
        data: {'image': dataUri},
      );
      final body = missionJsonMap(response.data);
      if (body['success'] == false) {
        return Failure(_responseError(body));
      }

      final image = body['image'];
      final data = missionJsonMap(body['data']);
      final imageObject = missionJsonMap(image);
      final dataImage = missionJsonMap(data['image']);
      final url =
          [
            body['imageUrl'],
            body['url'],
            image is String ? image : null,
            imageObject['url'],
            imageObject['imageUrl'],
            data['imageUrl'],
            data['url'],
            dataImage['url'],
          ].whereType<String>().firstWhere(
            (value) => value.trim().isNotEmpty,
            orElse: () => '',
          );

      if (url.isEmpty) {
        return Failure(
          const ApiErrorModel(message: 'لم يرجع الخادم رابط الصورة بعد رفعها'),
        );
      }
      return Success(url);
    } catch (error) {
      return Failure(ErrorHandler.handle(error));
    }
  }

  Future<ApiResult<bool>> checkIn({
    required int missionId,
    required double latitude,
    required double longitude,
  }) async {
    try {
      final response = await _dio.post(
        '${ApiConstants.endpointTaskAttendance}/$missionId/check-in',
        data: {'latitude': latitude, 'longitude': longitude},
      );
      final body = missionJsonMap(response.data);
      if (body['success'] == false) {
        return Failure(_responseError(body));
      }
      return Success(true);
    } catch (error) {
      return Failure(ErrorHandler.handle(error));
    }
  }

  Future<ApiResult<bool>> submitMissionReport({
    required int missionId,
    required String notes,
    required List<String> images,
    required int rating,
  }) async {
    try {
      final response = await _dio.post(
        '${ApiConstants.endpointMissions}/$missionId/report',
        data: {'notes': notes, 'images': images, 'rating': rating},
      );
      final body = missionJsonMap(response.data);
      if (body['success'] == false) {
        return Failure(_responseError(body));
      }
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
