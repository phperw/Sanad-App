import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      debugPrint('══════════════════════════════════');
      debugPrint('[ERROR INTERCEPTOR]');
      debugPrint('Type     : ${err.type}');
      debugPrint('Message  : ${err.message}');
      debugPrint('Status   : ${err.response?.statusCode}');
      debugPrint('══════════════════════════════════');
    }
    handler.next(err);
  }
}
