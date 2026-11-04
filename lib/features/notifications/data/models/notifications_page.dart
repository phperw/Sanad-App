import 'notification_item.dart';

class NotificationsPage {
  final List<NotificationItem> notifications;
  final int page;
  final int limit;
  final int total;
  final int pages;

  const NotificationsPage({
    required this.notifications,
    required this.page,
    required this.limit,
    required this.total,
    required this.pages,
  });

  factory NotificationsPage.fromJson(Map<String, dynamic> json) {
    final rawNotifications = json['notifications'];
    final pagination = _asMap(json['pagination']);

    return NotificationsPage(
      notifications: rawNotifications is List
          ? rawNotifications
                .whereType<Map>()
                .map(
                  (item) => NotificationItem.fromJson(
                    item.map((key, value) => MapEntry(key.toString(), value)),
                  ),
                )
                .toList()
          : const [],
      page: _asInt(pagination['page'], 1),
      limit: _asInt(pagination['limit'], 20),
      total: _asInt(pagination['total'], 0),
      pages: _asInt(pagination['pages'], 1),
    );
  }

  static Map<String, dynamic> _asMap(dynamic value) {
    if (value is! Map) return const {};
    return value.map((key, value) => MapEntry(key.toString(), value));
  }

  static int _asInt(dynamic value, int fallback) =>
      value is num ? value.toInt() : int.tryParse('$value') ?? fallback;
}
