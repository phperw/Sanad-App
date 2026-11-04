import 'package:flutter_test/flutter_test.dart';
import 'package:sanad/features/notifications/data/models/notification_item.dart';
import 'package:sanad/features/notifications/data/models/notifications_page.dart';

void main() {
  group('NotificationsPage', () {
    test('parses the backend page and notification contract', () {
      final page = NotificationsPage.fromJson({
        'pagination': {'page': 2, 'limit': 20, 'total': 21, 'pages': 2},
        'notifications': [
          {
            'id': 42,
            'title': 'تم قبول طلبك',
            'body': 'تم تحديث حالة طلب التطوع',
            'type': 'application',
            'data': {'applicationId': 7},
            'isRead': false,
            'createdAt': '2026-11-03T10:15:00Z',
            'readAt': null,
          },
        ],
      });

      expect(page.page, 2);
      expect(page.limit, 20);
      expect(page.total, 21);
      expect(page.pages, 2);
      expect(page.notifications, hasLength(1));
      expect(page.notifications.single.id, '42');
      expect(page.notifications.single.data['applicationId'], 7);
      expect(page.notifications.single.isRead, isFalse);
      expect(page.notifications.single.createdAt, isNotNull);
    });

    test('tolerates optional or malformed fields', () {
      final page = NotificationsPage.fromJson({
        'notifications': [
          {
            'id': 'n-1',
            'title': 'عنوان',
            'body': 'رسالة',
            'isRead': 'true',
            'createdAt': 'not-a-date',
            'data': null,
          },
        ],
      });

      expect(page.page, 1);
      expect(page.limit, 20);
      expect(page.pages, 1);
      expect(page.notifications.single.isRead, isTrue);
      expect(page.notifications.single.createdAt, isNull);
      expect(page.notifications.single.data, isEmpty);
    });
  });

  test('copyWith marks a notification as read without losing its payload', () {
    final notification = NotificationItem.fromJson({
      'id': 'n-2',
      'title': 'عنوان',
      'body': 'رسالة',
      'data': {'taskId': 3},
    });

    final read = notification.copyWith(isRead: true, readAt: DateTime(2026));

    expect(read.isRead, isTrue);
    expect(read.data, {'taskId': 3});
    expect(read.id, notification.id);
  });
}
