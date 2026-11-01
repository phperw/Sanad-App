import 'dart:async';
import 'package:dio/dio.dart';
import 'package:sanad/core/helper/shared_pref_helper.dart';
import 'package:sanad/core/networking/api_constants.dart';
import 'package:sanad/core/routing/router.dart';

class RefreshInterceptor extends Interceptor {
  RefreshInterceptor(this._dio);

  final Dio _dio;
  Future<bool>? _refreshing;

  static const String _retriedKey = 'retried_after_refresh';

  bool _isAuthPath(String path) {
    return path.contains(ApiConstants.endpointLogin) ||
        path.contains(ApiConstants.endpointRegister) ||
        path.contains(ApiConstants.endpointRefresh);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final request = err.requestOptions;

    if (err.response?.statusCode != 401 ||
        _isAuthPath(request.path) ||
        request.extra[_retriedKey] == true) {
      return handler.next(err);
    }

    final sentToken = request.headers['Authorization']
        ?.toString()
        .replaceFirst('Bearer ', '');
    final currentToken = SharedPrefHelper.getAccessToken();

    if (currentToken != null &&
        currentToken.isNotEmpty &&
        sentToken != currentToken) {
      return _retry(request, handler, err);
    }

    final refreshToken = SharedPrefHelper.getRefreshToken();

    if (refreshToken == null || refreshToken.isEmpty) {
      await _forceLogout();
      return handler.next(err);
    }

    _refreshing ??= _doRefresh(refreshToken);
    final refreshed = await _refreshing!;
    _refreshing = null;

    if (!refreshed) {
      await _forceLogout();
      return handler.next(err);
    }

    return _retry(request, handler, err);
  }

  Future<void> _retry(
    RequestOptions request,
    ErrorInterceptorHandler handler,
    DioException original,
  ) async {
    try {
      request.extra[_retriedKey] = true;
      request.headers['Authorization'] =
          'Bearer ${SharedPrefHelper.getAccessToken()}';
      final response = await _dio.fetch(request);
      handler.resolve(response);
    } on DioException catch (e) {
      handler.next(e);
    } catch (_) {
      handler.next(original);
    }
  }

  Future<bool> _doRefresh(String refreshToken) async {
    try {
      final refreshDio = Dio(
        BaseOptions(
          baseUrl: ApiConstants.baseURL,
          connectTimeout: const Duration(seconds: 30),
          receiveTimeout: const Duration(seconds: 30),
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
        ),
      );

      final response = await refreshDio.post(
        ApiConstants.endpointRefresh,
        data: {'refreshToken': refreshToken},
      );

      final data = response.data as Map<String, dynamic>;
      final newAccess = data['accessToken'] as String?;
      final newRefresh = data['refreshToken'] as String?;

      if (newAccess == null || newRefresh == null) return false;

      await SharedPrefHelper.saveTokens(
        accessToken: newAccess,
        refreshToken: newRefresh,
      );
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> _forceLogout() async {
    await SharedPrefHelper.clearTokens();
    AppRouter.router.go(AppRouter.klogin);
  }
}