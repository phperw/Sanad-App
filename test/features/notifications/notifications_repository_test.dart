import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sanad/core/networking/api_result.dart';
import 'package:sanad/features/notifications/data/models/notifications_page.dart';
import 'package:sanad/features/notifications/data/notifications_repository.dart';

void main() {
  late Dio dio;
  late NotificationsRepository repository;
  late List<RequestOptions> requests;

  setUp(() {
    requests = [];
    dio = Dio(BaseOptions(baseUrl: 'https://api.example.test'));
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          requests.add(options);
          final data = switch (options.uri.path) {
            '/notifications' => {
              'success': true,
              'pagination': {
                'page': options.queryParameters['page'],
                'limit': options.queryParameters['limit'],
                'total': 1,
                'pages': 1,
              },
              'notifications': [
                {
                  'id': 'n-1',
                  'title': 'عنوان',
                  'body': 'رسالة',
                  'isRead': false,
                },
              ],
            },
            '/notifications/unread-count' => {
              'success': true,
              'unreadCount': 1,
            },
            '/notifications/read-all' => {
              'success': true,
              'updatedCount': 1,
            },
            _ => {'success': true},
          };
          handler.resolve(
            Response(
              requestOptions: options,
              statusCode: 200,
              data: data,
            ),
          );
        },
      ),
    );
    repository = NotificationsRepository(dio);
  });

  test('loads list and unread count with the specified query contract', () async {
    final result = await repository.getNotifications(page: 2, limit: 20);
    final unreadCount = await repository.getUnreadCount();

    expect(result, isA<Success<NotificationsPage>>());
    expect(requests[0].method, 'GET');
    expect(requests[0].uri.path, '/notifications');
    expect(requests[0].queryParameters, {'page': 2, 'limit': 20});
    expect(unreadCount, isA<Success<int>>());
    expect((unreadCount as Success<int>).data, 1);
    expect(requests[1].uri.path, '/notifications/unread-count');
  });

  test('sends state changes and device payloads to their contracts', () async {
    await repository.markAsRead('n-1');
    await repository.markAllAsRead();
    await repository.deleteNotification('n-1');
    await repository.registerDevice(
      fcmToken: 'opaque-token',
      platform: 'android',
    );
    await repository.unregisterDevice(fcmToken: 'opaque-token');

    expect(
      requests.map((request) => '${request.method} ${request.uri.path}'),
      [
        'PATCH /notifications/n-1/read',
        'PATCH /notifications/read-all',
        'DELETE /notifications/n-1',
        'POST /notifications/devices',
        'DELETE /notifications/devices',
      ],
    );
    expect(requests[3].data, {
      'fcmToken': 'opaque-token',
      'platform': 'android',
    });
    expect(requests[4].data, {'fcmToken': 'opaque-token'});
  });

  test('returns a failure for an unsuccessful backend response', () async {
    dio.interceptors.clear();
    dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) => handler.resolve(
          Response(
            requestOptions: options,
            statusCode: 200,
            data: {'success': false, 'message': 'تعذر تحميل الإشعارات'},
          ),
        ),
      ),
    );
    final result = await repository.getNotifications();

    expect(result, isA<Failure<NotificationsPage>>());
    expect(
      (result as Failure<NotificationsPage>).error.message,
      'تعذر تحميل الإشعارات',
    );
  });
}
