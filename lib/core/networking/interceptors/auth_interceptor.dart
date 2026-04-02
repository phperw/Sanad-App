import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../../helper/shared_pref_helper.dart';

class AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = SharedPrefHelper.getAccessToken();

    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
      if (kDebugMode) debugPrint('[AUTH] Token attached ✓');
    } else {
      if (kDebugMode) debugPrint('[AUTH] No token — request sent without auth');
    }

    handler.next(options);
  }
}
