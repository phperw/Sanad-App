import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class FileLoggerInterceptor extends Interceptor {
  Future<File?> _getFile() async {
    if (!kDebugMode) return null;
    try {
      final dir = await getApplicationDocumentsDirectory();
      final now = DateTime.now();
      final fileName =
          'api_logs_${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}.txt';
      return File('${dir.path}/$fileName');
    } catch (_) {
      return null;
    }
  }

  // دالة الكتابة الجديدة والمعدلة
  Future<void> _write(String content) async {
    final file = await _getFile();
    if (file != null) {
      try {
        // ignore: prefer_interpolation_to_compose_strings
        await file.writeAsString(content + '\n', mode: FileMode.append);
      } catch (_) {}
    }
  }

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    await _write('''
[REQUEST] ${DateTime.now()}
${options.method} ${options.uri}
Headers : ${options.headers}
Body    : ${options.data}
──────────────────────────────────''');

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    final body = response.data.toString();
    final truncated = body.length > 3000
        ? '${body.substring(0, 3000)}...[truncated]'
        : body;

    await _write('''
[RESPONSE] ${DateTime.now()}
Status  : ${response.statusCode}
Body    : $truncated
──────────────────────────────────''');

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    await _write('''
[ERROR] ${DateTime.now()}
Type    : ${err.type}
Message : ${err.message}
Status  : ${err.response?.statusCode}
──────────────────────────────────''');

    handler.next(err);
  }
}
