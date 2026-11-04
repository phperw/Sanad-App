import 'package:dio/dio.dart';
import 'package:sanad/core/networking/api_error_model.dart';
import 'package:sanad/core/networking/api_result.dart';
import 'admin_api_client.dart';
import 'admin_secure_storage.dart';

class AdminSession {
  final String accessToken;
  final String refreshToken;
  final String email;
  final String fullName;
  final String role;
  final bool mustChangePassword;

  const AdminSession({
    required this.accessToken,
    required this.refreshToken,
    required this.email,
    required this.fullName,
    required this.role,
    required this.mustChangePassword,
  });

  factory AdminSession.fromJson(Map<String, dynamic> json) {
    final admin = json['admin'];
    if (admin is! Map<String, dynamic> ||
        json['accessToken'] is! String ||
        json['refreshToken'] is! String) {
      throw const FormatException('استجابة تسجيل الدخول غير مكتملة');
    }
    return AdminSession(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      email: admin['email'] as String? ?? '',
      fullName: admin['fullName'] as String? ?? '',
      role: admin['role'] as String? ?? '',
      mustChangePassword: admin['mustChangePassword'] == true,
    );
  }
}

class AdminRepository {
  AdminRepository(this.client, this.storage);

  final AdminApiClient client;
  final AdminSecureStorage storage;

  Future<ApiResult<AdminSession>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await client.dio.post(
        '/admin-auth/login',
        data: {'email': email, 'password': password},
      );
      final data = response.data;
      if (data is! Map<String, dynamic> || data['success'] != true) {
        return Failure(_apiError(data));
      }
      final session = AdminSession.fromJson(data);
      await storage.saveTokens(
        accessToken: session.accessToken,
        refreshToken: session.refreshToken,
      );
      return Success(session);
    } on DioException catch (error) {
      return Failure(
        _apiError(error.response?.data, error.response?.statusCode),
      );
    } on FormatException catch (error) {
      return Failure(ApiErrorModel(message: error.message));
    }
  }

  Future<ApiResult<Map<String, dynamic>>> dashboard() =>
      _request(() async => (await client.dio.get('/admin/dashboard')).data);

  Future<ApiResult<Map<String, dynamic>>> loadSection(
    String section, {
    int page = 1,
  }) {
    const endpoints = <String, String>{
      'volunteers': '/admin/volunteers',
      'accounts': '/admin/accounts',
      'campaigns': '/campaigns',
      'tasks': '/tasks',
      'reports': '/reports/pending-review',
      'emergencies': '/admin/emergency/incidents',
      'audit': '/admin/audit-logs',
    };
    final endpoint = endpoints[section];
    if (endpoint == null) {
      return Future.value(
        Failure(const ApiErrorModel(message: 'القسم غير متاح')),
      );
    }
    return _request(
      () async => (await client.dio.get(
        endpoint,
        queryParameters: {'page': page, 'limit': 20},
      )).data,
    );
  }

  Future<ApiResult<Map<String, dynamic>>> missionRequests(
    int taskId, {
    int page = 1,
  }) => _request(
    () async => (await client.dio.get(
      '/missions/$taskId/join-requests',
      queryParameters: {'page': page, 'limit': 20},
    )).data,
  );

  Future<ApiResult<Map<String, dynamic>>> createAdminAccount({
    required String fullName,
    required String email,
    required String password,
  }) => _request(
    () async => (await client.dio.post(
      '/admin/accounts',
      data: {'fullName': fullName, 'email': email, 'password': password},
    )).data,
  );

  Future<ApiResult<Map<String, dynamic>>> updateAdminAccount(
    int adminId,
    Map<String, dynamic> changes,
  ) => _request(
    () async => (await client.dio.patch(
      '/admin/accounts/$adminId',
      data: changes,
    )).data,
  );

  Future<ApiResult<Map<String, dynamic>>> resetAdminPassword({
    required int adminId,
    required String newPassword,
  }) => _request(
    () async => (await client.dio.patch(
      '/admin/accounts/$adminId/password-reset',
      data: {'newPassword': newPassword},
    )).data,
  );

  Future<ApiResult<Map<String, dynamic>>> createCampaign(
    Map<String, dynamic> body,
  ) => _request(
    () async => (await client.dio.post('/campaigns', data: body)).data,
  );

  Future<ApiResult<Map<String, dynamic>>> createTask(
    Map<String, dynamic> body,
  ) => _request(() async => (await client.dio.post('/tasks', data: body)).data);

  Future<ApiResult<Map<String, dynamic>>> updateMissionApproval({
    required int taskId,
    required String status,
  }) => _request(
    () async => (await client.dio.patch(
      '/missions/$taskId/approval',
      data: {'status': status},
    )).data,
  );

  Future<ApiResult<Map<String, dynamic>>> decideJoinRequest({
    required int taskId,
    required int requestId,
    required bool approve,
    String? reason,
  }) => _request(
    () async => (await client.dio.patch(
      '/missions/$taskId/join-requests/$requestId/${approve ? 'approve' : 'reject'}',
      data: approve ? null : _reasonBody(reason),
    )).data,
  );

  Future<ApiResult<Map<String, dynamic>>> decideReport({
    required int reportId,
    required bool approve,
    String? reason,
  }) => _request(
    () async => (await client.dio.patch(
      '/reports/$reportId/${approve ? 'approve' : 'reject'}',
      data: approve ? null : _reasonBody(reason),
    )).data,
  );

  Future<ApiResult<Map<String, dynamic>>> changeEmergencyStatus({
    required int incidentId,
    required String status,
    String? notes,
  }) => _request(
    () async => (await client.dio.patch(
      '/admin/emergency/incidents/$incidentId/status',
      data: {'status': status, if (notes case final value?) 'notes': value},
    )).data,
  );

  Future<ApiResult<void>> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final result = await _request(
      () async => (await client.dio.post(
        '/admin-auth/change-password',
        data: {'currentPassword': currentPassword, 'newPassword': newPassword},
      )).data,
    );
    return switch (result) {
      Success() => Success(null),
      Failure(:final error) => Failure(error),
    };
  }

  Future<void> logout() async {
    final refreshToken = await storage.readRefreshToken();
    try {
      if (refreshToken != null && refreshToken.isNotEmpty) {
        await client.dio.post(
          '/admin-auth/logout',
          data: {'refreshToken': refreshToken},
        );
      }
    } finally {
      await storage.clearTokens();
    }
  }

  Future<ApiResult<Map<String, dynamic>>> _request(
    Future<dynamic> Function() call,
  ) async {
    try {
      final data = await call();
      if (data is! Map<String, dynamic>) {
        return Failure(
          const ApiErrorModel(message: 'استجابة غير صالحة من الخادم'),
        );
      }
      if (data['success'] == false) return Failure(_apiError(data));
      return Success(data);
    } on DioException catch (error) {
      return Failure(
        _apiError(error.response?.data, error.response?.statusCode),
      );
    }
  }

  ApiErrorModel _apiError(dynamic data, [int? statusCode]) {
    if (data is Map<String, dynamic>) {
      return ApiErrorModel.fromJson({...data, 'statusCode': statusCode});
    }
    return ApiErrorModel(
      message: statusCode == 401
          ? 'انتهت الجلسة، يرجى تسجيل الدخول مجدداً'
          : 'تعذر الاتصال بالخادم',
      statusCode: statusCode,
    );
  }

  Map<String, String>? _reasonBody(String? reason) {
    final trimmed = reason?.trim();
    if (trimmed == null || trimmed.isEmpty) return null;
    return {'reason': trimmed};
  }
}
