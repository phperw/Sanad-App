import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:sanad/core/helper/storage.dart';
import 'package:sanad/core/networking/api_constants.dart';
class ApiDioService {
  final Dio dio;
 final StorageHelper storageHelper = StorageHelper();
   ApiDioService()
      : dio = Dio(
          BaseOptions(
            baseUrl: ApiEndpoints.baseUrl,
            headers: {
              "Content-Type": "application/json",
              "Accept": "application/json",
            },
          ),
        ) {
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          String? token = await storageHelper.getToken();
          if (token != null && token.isNotEmpty) {
            options.headers["Authorization"] = "Bearer $token";
          }
          return handler.next(options);
        },
      ),
    );
  }
  Future<Response?> getRequest({
  required String endpoint,
  Map<String, dynamic>? query,
}) async {
  try {
    Response response = await dio.get(
      endpoint,
      queryParameters: query,
    );
    return response;
  } catch (e) {
    log(e.toString());
    return null;
  }
}
  Future<Response> post({
    required String endpoint,
    required Map<String, dynamic> data,
  }) async {
    return await dio.post(endpoint, data: data);
  }
Future<Response> delete({
  required String endpoint,
}) async {
  return await dio.delete(endpoint);
}
}
