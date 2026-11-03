import 'dart:async';
import 'package:dio/dio.dart';
import 'package:sanad/core/helper/shared_pref_helper.dart';
import 'package:sanad/core/networking/api_constants.dart';
import 'package:sanad/core/routing/router.dart';

enum _RefreshResult { success, rejected, unavailable }

class RefreshInterceptor extends Interceptor {
  RefreshInterceptor(this._dio);

  final Dio _dio;
  Future<_RefreshResult>? _refreshing;

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

    final sentToken = request.headers['Authorization']?.toString().replaceFirst(
      'Bearer ',
      '',
    );
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

    _refreshing ??= _doRefresh(refreshToken).whenComplete(() {
      _refreshing = null;
    });

    final result = await _refreshing!;

    switch (result) {
      case _RefreshResult.success:
        return _retry(request, handler, err);
      case _RefreshResult.rejected:
        if (SharedPrefHelper.getRefreshToken() != refreshToken) {
          return _retry(request, handler, err);
        }
        await _forceLogout();
        return handler.next(err);
      case _RefreshResult.unavailable:
        return handler.next(err);
    }
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

  Future<_RefreshResult> _doRefresh(String refreshToken) async {
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

      final data = response.data;
      if (data is! Map<String, dynamic>) return _RefreshResult.unavailable;

      final newAccess = data['accessToken'];
      final newRefresh = data['refreshToken'];
      if (newAccess is! String || newRefresh is! String) {
        return _RefreshResult.unavailable;
      }

      await SharedPrefHelper.saveTokens(
        accessToken: newAccess,
        refreshToken: newRefresh,
      );
      return _RefreshResult.success;
    } on DioException catch (e) {
      final status = e.response?.statusCode;
      if (status == 400 || status == 401 || status == 403) {
        return _RefreshResult.rejected;
      }
      return _RefreshResult.unavailable;
    } catch (_) {
      return _RefreshResult.unavailable;
    }
  }

  Future<void> _forceLogout() async {
    await SharedPrefHelper.clearTokens();
    AppRouter.router.go(AppRouter.klogin);
  }
}
