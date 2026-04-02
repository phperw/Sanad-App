import 'package:dio/dio.dart';
import 'api_error_model.dart';

class ErrorHandler {
  ErrorHandler._();

  static ApiErrorModel handle(dynamic error) {
    if (error is DioException) {
      return _handleDioException(error);
    }
    return const ApiErrorModel(message: 'حدث خطأ غير متوقع');
  }

  static ApiErrorModel _handleDioException(DioException e) {
    switch (e.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const ApiErrorModel(
          message: 'انتهت مهلة الاتصال، حاول مرة أخرى',
          statusCode: 408,
        );

      case DioExceptionType.badResponse:
        try {
          return ApiErrorModel.fromJson(
            e.response?.data as Map<String, dynamic>,
          );
        } catch (_) {
          return ApiErrorModel(
            message: 'حدث خطأ من السيرفر',
            statusCode: e.response?.statusCode,
          );
        }

      case DioExceptionType.connectionError:
        return const ApiErrorModel(message: 'لا يوجد اتصال بالإنترنت');

      case DioExceptionType.cancel:
        return const ApiErrorModel(message: 'تم إلغاء الطلب');

      case DioExceptionType.badCertificate:
        return const ApiErrorModel(message: 'خطأ في الشهادة الأمنية');

      case DioExceptionType.unknown:
        return const ApiErrorModel(message: 'حدث خطأ غير متوقع');
    }
  }
}
