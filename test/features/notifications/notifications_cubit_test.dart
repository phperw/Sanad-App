import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sanad/core/networking/api_error_model.dart';
import 'package:sanad/core/networking/api_result.dart';
import 'package:sanad/features/notifications/data/models/notification_item.dart';
import 'package:sanad/features/notifications/data/models/notifications_page.dart';
import 'package:sanad/features/notifications/data/notifications_repository.dart';
import 'package:sanad/features/notifications/logic/notifications_cubit.dart';

class _FakeNotificationsRepository extends NotificationsRepository {
  _FakeNotificationsRepository() : super(Dio());

  final Map<int, NotificationsPage> pages = {
    1: _page(1, 2, [
      _notification('1', isRead: false),
      _notification('2', isRead: true),
    ]),
    2: _page(2, 2, [_notification('3', isRead: false)]),
  };
  final List<String> calls = [];
  int unreadCount = 2;
  String? failure;

  @override
  Future<ApiResult<NotificationsPage>> getNotifications({
    int page = 1,
    int limit = 20,
  }) async {
    calls.add('list:$page:$limit');
    if (failure != null) {
      return Failure(ApiErrorModel(message: failure!));
    }
    return Success(pages[page]!);
  }

  @override
  Future<ApiResult<int>> getUnreadCount() async {
    calls.add('count');
    if (failure != null) return Failure(ApiErrorModel(message: failure!));
    return Success(unreadCount);
  }

  @override
  Future<ApiResult<bool>> markAsRead(String notificationId) async {
    calls.add('read:$notificationId');
    if (failure != null) return Failure(ApiErrorModel(message: failure!));
    return Success(true);
  }

  @override
  Future<ApiResult<int>> markAllAsRead() async {
    calls.add('read-all');
    if (failure != null) return Failure(ApiErrorModel(message: failure!));
    return Success(1);
  }

  @override
  Future<ApiResult<bool>> deleteNotification(String notificationId) async {
    calls.add('delete:$notificationId');
    if (failure != null) return Failure(ApiErrorModel(message: failure!));
    return Success(true);
  }
}

NotificationItem _notification(String id, {required bool isRead}) =>
    NotificationItem(id: id, title: 'عنوان $id', body: 'رسالة', isRead: isRead);

NotificationsPage _page(
  int page,
  int pages,
  List<NotificationItem> notifications,
) => NotificationsPage(
  notifications: notifications,
  page: page,
  limit: 20,
  total: 3,
  pages: pages,
);

void main() {
  late _FakeNotificationsRepository repository;
  late NotificationsCubit cubit;

  setUp(() {
    repository = _FakeNotificationsRepository();
    cubit = NotificationsCubit(repository);
  });

  tearDown(() async {
    await cubit.close();
  });

  test('loads page one, unread count, and appends the next page', () async {
    await cubit.loadInitial();
    expect(cubit.state.notifications.map((item) => item.id), ['1', '2']);
    expect(cubit.state.unreadCount, 2);

    await cubit.loadMore();
    expect(cubit.state.notifications.map((item) => item.id), ['1', '2', '3']);
    expect(cubit.state.page, 2);
    expect(cubit.state.hasMore, isFalse);
    expect(repository.calls, ['list:1:20', 'count', 'list:2:20']);
  });

  test(
    'marks individual/all items read and decrements unread on deletion',
    () async {
      await cubit.loadInitial();
      await cubit.markAsRead('1');
      expect(cubit.state.notifications.first.isRead, isTrue);
      expect(cubit.state.unreadCount, 1);

      await cubit.markAllAsRead();
      expect(cubit.state.notifications.every((item) => item.isRead), isTrue);
      expect(cubit.state.unreadCount, 0);

      await cubit.delete('2');
      expect(cubit.state.notifications.map((item) => item.id), ['1']);
      expect(cubit.state.unreadCount, 0);
      expect(repository.calls, containsAll(['read:1', 'read-all', 'delete:2']));
    },
  );

  test('keeps list retryable after an API failure', () async {
    repository.failure = 'تعذر التحميل';
    await cubit.loadInitial();
    expect(cubit.state.errorMessage, 'تعذر التحميل');
    expect(cubit.state.isLoading, isFalse);

    repository.failure = null;
    await cubit.refresh();
    expect(cubit.state.errorMessage, isNull);
    expect(cubit.state.notifications, hasLength(2));
  });
}
