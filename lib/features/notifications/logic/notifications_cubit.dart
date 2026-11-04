import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanad/core/networking/api_result.dart';

import '../data/models/notification_item.dart';
import '../data/notifications_repository.dart';

class NotificationsState {
  final List<NotificationItem> notifications;
  final int page;
  final int totalPages;
  final int unreadCount;
  final bool isLoading;
  final bool isLoadingMore;
  final String? errorMessage;
  final String? actionErrorMessage;

  const NotificationsState({
    this.notifications = const [],
    this.page = 1,
    this.totalPages = 1,
    this.unreadCount = 0,
    this.isLoading = false,
    this.isLoadingMore = false,
    this.errorMessage,
    this.actionErrorMessage,
  });

  bool get hasMore => page < totalPages;

  NotificationsState copyWith({
    List<NotificationItem>? notifications,
    int? page,
    int? totalPages,
    int? unreadCount,
    bool? isLoading,
    bool? isLoadingMore,
    String? errorMessage,
    String? actionErrorMessage,
    bool clearError = false,
    bool clearActionError = false,
  }) {
    return NotificationsState(
      notifications: notifications ?? this.notifications,
      page: page ?? this.page,
      totalPages: totalPages ?? this.totalPages,
      unreadCount: unreadCount ?? this.unreadCount,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      actionErrorMessage: clearActionError
          ? null
          : actionErrorMessage ?? this.actionErrorMessage,
    );
  }
}

class NotificationsCubit extends Cubit<NotificationsState> {
  final NotificationsRepository _repository;
  static const int pageSize = 20;

  NotificationsCubit(this._repository) : super(const NotificationsState());

  Future<void> loadInitial() => refresh();

  Future<void> refresh() async {
    if (state.isLoading) return;
    emit(
      state.copyWith(isLoading: true, clearError: true, clearActionError: true),
    );

    final pageResult = await _repository.getNotifications(
      page: 1,
      limit: pageSize,
    );
    if (isClosed) return;

    switch (pageResult) {
      case Success(:final data):
        final countResult = await _repository.getUnreadCount();
        if (isClosed) return;
        emit(
          state.copyWith(
            notifications: data.notifications,
            page: data.page,
            totalPages: data.pages,
            unreadCount: switch (countResult) {
              Success(:final data) => data,
              Failure() => _unreadIn(data.notifications),
            },
            isLoading: false,
            clearError: true,
          ),
        );
      case Failure(:final error):
        emit(
          state.copyWith(isLoading: false, errorMessage: error.message),
        );
    }
  }

  Future<void> loadMore() async {
    if (state.isLoading || state.isLoadingMore || !state.hasMore) return;
    emit(state.copyWith(isLoadingMore: true, clearActionError: true));

    final nextPage = state.page + 1;
    final result = await _repository.getNotifications(
      page: nextPage,
      limit: pageSize,
    );
    if (isClosed) return;
    switch (result) {
      case Success(:final data):
        final existingIds = state.notifications.map((item) => item.id).toSet();
        final additions = data.notifications
            .where((item) => !existingIds.contains(item.id))
            .toList();
        emit(
          state.copyWith(
            notifications: [...state.notifications, ...additions],
            page: data.page,
            totalPages: data.pages,
            isLoadingMore: false,
            clearActionError: true,
          ),
        );
      case Failure(:final error):
        emit(
          state.copyWith(
            isLoadingMore: false,
            actionErrorMessage: error.message,
          ),
        );
    }
  }

  Future<void> markAsRead(String id) async {
    final notification = _find(id);
    if (notification == null || notification.isRead) return;
    final result = await _repository.markAsRead(id);
    if (isClosed) return;
    switch (result) {
      case Success():
        emit(
          state.copyWith(
            notifications: _replace(
              id,
              notification.copyWith(isRead: true, readAt: DateTime.now()),
            ),
            unreadCount: (state.unreadCount - 1).clamp(0, 1 << 31).toInt(),
            clearActionError: true,
          ),
        );
      case Failure(:final error):
        emit(state.copyWith(actionErrorMessage: error.message));
    }
  }

  Future<void> markAllAsRead() async {
    if (state.unreadCount == 0) return;
    final result = await _repository.markAllAsRead();
    if (isClosed) return;
    switch (result) {
      case Success():
        emit(
          state.copyWith(
            notifications: state.notifications
                .map(
                  (item) => item.isRead
                      ? item
                      : item.copyWith(isRead: true, readAt: DateTime.now()),
                )
                .toList(),
            unreadCount: 0,
            clearActionError: true,
          ),
        );
      case Failure(:final error):
        emit(state.copyWith(actionErrorMessage: error.message));
    }
  }

  Future<void> delete(String id) async {
    final notification = _find(id);
    if (notification == null) return;
    final result = await _repository.deleteNotification(id);
    if (isClosed) return;
    switch (result) {
      case Success():
        emit(
          state.copyWith(
            notifications: state.notifications
                .where((item) => item.id != id)
                .toList(),
            unreadCount: notification.isRead
                ? state.unreadCount
                : (state.unreadCount - 1).clamp(0, 1 << 31).toInt(),
            clearActionError: true,
          ),
        );
      case Failure(:final error):
        emit(state.copyWith(actionErrorMessage: error.message));
    }
  }

  void clearActionError() {
    emit(state.copyWith(clearActionError: true));
  }

  NotificationItem? _find(String id) {
    for (final item in state.notifications) {
      if (item.id == id) return item;
    }
    return null;
  }

  List<NotificationItem> _replace(String id, NotificationItem replacement) =>
      state.notifications
          .map((item) => item.id == id ? replacement : item)
          .toList();

  int _unreadIn(List<NotificationItem> items) =>
      items.where((item) => !item.isRead).length;
}
