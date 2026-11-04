import 'package:dio/dio.dart';
import 'package:sanad/core/networking/api_constants.dart';
import 'admin_secure_storage.dart';

class AdminApiClient {
  AdminApiClient(this.storage) {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConstants.baseURL,
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: const {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
      ),
    );
    dio.interceptors.add(_AdminAuthInterceptor(storage));
  }

  final AdminSecureStorage storage;
  late final Dio dio;
}

class _AdminAuthInterceptor extends Interceptor {
  _AdminAuthInterceptor(this._storage);

  final AdminSecureStorage _storage;

  bool _isPublicAdminAuthPath(String path) =>
      path == '/admin-auth/login' ||
      path == '/admin-auth/refresh' ||
      path == '/admin-auth/logout';

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    if (!_isPublicAdminAuthPath(options.path)) {
      final token = await _storage.readAccessToken();
      if (token != null && token.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $token';
      }
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException error,
    ErrorInterceptorHandler handler,
  ) async {
    final request = error.requestOptions;
    if (error.response?.statusCode != 401 ||
        _isPublicAdminAuthPath(request.path) ||
        request.extra['adminRetried'] == true) {
      handler.next(error);
      return;
    }

    final refreshToken = await _storage.readRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      await _storage.clearTokens();
      handler.next(error);
      return;
    }

    try {
      final response = await Dio(
        BaseOptions(baseUrl: ApiConstants.baseURL),
      ).post('/admin-auth/refresh', data: {'refreshToken': refreshToken});
      final body = response.data;
      if (body is! Map<String, dynamic> ||
          body['accessToken'] is! String ||
          body['refreshToken'] is! String) {
        await _storage.clearTokens();
        handler.next(error);
        return;
      }

      final accessToken = body['accessToken'] as String;
      await _storage.saveTokens(
        accessToken: accessToken,
        refreshToken: body['refreshToken'] as String,
      );
      request
        ..extra['adminRetried'] = true
        ..headers['Authorization'] = 'Bearer $accessToken';
      handler.resolve(
        await Dio(BaseOptions(baseUrl: ApiConstants.baseURL)).fetch(request),
      );
    } on DioException catch (refreshError) {
      if (refreshError.response?.statusCode == 400 ||
          refreshError.response?.statusCode == 401 ||
          refreshError.response?.statusCode == 403) {
        await _storage.clearTokens();
      }
      handler.next(error);
    } catch (_) {
      handler.next(error);
    }
  }
}
