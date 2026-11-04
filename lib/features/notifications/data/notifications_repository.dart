import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:sanad/core/networking/api_error_model.dart';
import 'package:sanad/core/networking/api_result.dart';
import 'package:sanad/core/networking/error_hander.dart';
import 'package:sanad/core/networking/interceptors/file_logger_interceptor.dart';
import 'package:sanad/core/networking/interceptors/refresh_interceptor.dart';

import 'models/notifications_page.dart';

class NotificationsRepository {
  final Dio _dio;

  NotificationsRepository(this._dio);

  Future<ApiResult<NotificationsPage>> getNotifications({
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _dio.get(
        '/notifications',
        queryParameters: {'page': page, 'limit': limit},
      );
      final body = _asMap(response.data);
      if (body['success'] == false) return Failure(_responseError(body));
      return Success(NotificationsPage.fromJson(body));
    } catch (error) {
      return Failure(ErrorHandler.handle(error));
    }
  }

  Future<ApiResult<int>> getUnreadCount() async {
    try {
      final response = await _dio.get('/notifications/unread-count');
      final body = _asMap(response.data);
      if (body['success'] == false) return Failure(_responseError(body));
      return Success(_asInt(body['unreadCount']));
    } catch (error) {
      return Failure(ErrorHandler.handle(error));
    }
  }

  Future<ApiResult<bool>> markAsRead(String notificationId) async {
    return _perform<bool>(
      () => _dio.patch(
        '/notifications/${Uri.encodeComponent(notificationId)}/read',
      ),
      (_) => true,
    );
  }

  Future<ApiResult<int>> markAllAsRead() async {
    return _perform<int>(
      () => _dio.patch('/notifications/read-all'),
      (body) => _asInt(body['updatedCount']),
    );
  }

  Future<ApiResult<bool>> deleteNotification(String notificationId) async {
    return _perform<bool>(
      () => _dio.delete(
        '/notifications/${Uri.encodeComponent(notificationId)}',
      ),
      (_) => true,
    );
  }

  Future<ApiResult<bool>> registerDevice({
    required String fcmToken,
    required String platform,
  }) {
    return _perform<bool>(
      () => _deviceDio().post(
        '/notifications/devices',
        data: {'fcmToken': fcmToken, 'platform': platform},
      ),
      (_) => true,
    );
  }

  Future<ApiResult<bool>> unregisterDevice({required String fcmToken}) {
    return _perform<bool>(
      () => _deviceDio().delete(
        '/notifications/devices',
        data: {'fcmToken': fcmToken},
      ),
      (_) => true,
    );
  }

  Future<ApiResult<T>> _perform<T>(
    Future<Response<dynamic>> Function() request,
    T Function(Map<String, dynamic>) read,
  ) async {
    try {
      final response = await request();
      final body = _asMap(response.data);
      if (body['success'] == false) return Failure(_responseError(body));
      return Success(read(body));
    } catch (error) {
      return Failure(ErrorHandler.handle(error));
    }
  }

  Dio _deviceDio() {
    final dio = Dio(_dio.options);
    dio.interceptors.addAll(
      _dio.interceptors.where(
        (interceptor) =>
            interceptor is! PrettyDioLogger &&
            interceptor is! FileLoggerInterceptor &&
            interceptor is! RefreshInterceptor,
      ),
    );
    return dio;
  }

  ApiErrorModel _responseError(Map<String, dynamic> body) {
    final message = body['message'] ?? body['error'];
    if (message is String && message.trim().isNotEmpty) {
      return ApiErrorModel(message: message);
    }
    return const ApiErrorModel(message: 'تعذر إكمال الطلب');
  }

  static Map<String, dynamic> _asMap(dynamic value) {
    if (value is! Map) return const {};
    return value.map((key, value) => MapEntry(key.toString(), value));
  }

  static int _asInt(dynamic value) =>
      value is num ? value.toInt() : int.tryParse('$value') ?? 0;
}
