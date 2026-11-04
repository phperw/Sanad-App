import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/models/notification_item.dart';
import '../logic/notifications_cubit.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<NotificationsCubit>().loadInitial();
    });
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.extentAfter < 240) {
      context.read<NotificationsCubit>().loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocListener<NotificationsCubit, NotificationsState>(
      listenWhen: (previous, current) =>
          previous.actionErrorMessage != current.actionErrorMessage &&
          current.actionErrorMessage != null,
      listener: (context, state) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(state.actionErrorMessage!)));
        context.read<NotificationsCubit>().clearActionError();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('الإشعارات'),
          actions: [
            BlocBuilder<NotificationsCubit, NotificationsState>(
              buildWhen: (previous, current) =>
                  previous.unreadCount != current.unreadCount,
              builder: (context, state) => state.unreadCount == 0
                  ? const SizedBox.shrink()
                  : TextButton(
                      onPressed: context
                          .read<NotificationsCubit>()
                          .markAllAsRead,
                      child: const Text('قراءة الكل'),
                    ),
            ),
          ],
        ),
        body: BlocBuilder<NotificationsCubit, NotificationsState>(
          builder: (context, state) {
            if (state.isLoading && state.notifications.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state.errorMessage != null && state.notifications.isEmpty) {
              return RefreshIndicator(
                onRefresh: context.read<NotificationsCubit>().refresh,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    const SizedBox(height: 130),
                    _MessageState(
                      icon: Icons.cloud_off_outlined,
                      message: state.errorMessage!,
                      actionLabel: 'إعادة المحاولة',
                      onAction: context.read<NotificationsCubit>().refresh,
                    ),
                  ],
                ),
              );
            }

            if (!state.isLoading && state.notifications.isEmpty) {
              return RefreshIndicator(
                onRefresh: context.read<NotificationsCubit>().refresh,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: const [
                    SizedBox(height: 150),
                    _MessageState(
                      icon: Icons.notifications_none_rounded,
                      message: 'لا توجد إشعارات حالياً',
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: [
                if (state.errorMessage != null)
                  MaterialBanner(
                    content: Text(state.errorMessage!),
                    actions: [
                      TextButton(
                        onPressed: context.read<NotificationsCubit>().refresh,
                        child: const Text('إعادة المحاولة'),
                      ),
                    ],
                  ),
                Expanded(
                  child: RefreshIndicator(
                    onRefresh: context.read<NotificationsCubit>().refresh,
                    child: ListView.builder(
                      controller: _scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      itemCount:
                          state.notifications.length +
                          (state.isLoadingMore || state.hasMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index >= state.notifications.length) {
                          if (state.isLoadingMore) {
                            return const Padding(
                              padding: EdgeInsets.all(20),
                              child: Center(child: CircularProgressIndicator()),
                            );
                          }
                          return Center(
                            child: TextButton(
                              onPressed: context
                                  .read<NotificationsCubit>()
                                  .loadMore,
                              child: const Text('تحميل المزيد'),
                            ),
                          );
                        }
                        final notification = state.notifications[index];
                        return _NotificationTile(
                          notification: notification,
                          onTap: () => _showDetails(context, notification),
                          onRead: notification.isRead
                              ? null
                              : () => context
                                    .read<NotificationsCubit>()
                                    .markAsRead(notification.id),
                          onDelete: () =>
                              _confirmDelete(context, notification),
                        );
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        ),
        backgroundColor: theme.scaffoldBackgroundColor,
      ),
    );
  }

  Future<void> _showDetails(
    BuildContext context,
    NotificationItem notification,
  ) async {
    if (!notification.isRead) {
      await context.read<NotificationsCubit>().markAsRead(notification.id);
    }
    if (!context.mounted) return;
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                notification.title,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 12),
              Text(notification.body),
              if (notification.createdAt != null) ...[
                const SizedBox(height: 20),
                Text(
                  _formatDate(notification.createdAt!),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    NotificationItem notification,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('حذف الإشعار؟'),
        content: const Text('لن يظهر هذا الإشعار في قائمتك بعد حذفه.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('إلغاء'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('حذف'),
          ),
        ],
      ),
    );
    if (confirmed == true && context.mounted) {
      await context.read<NotificationsCubit>().delete(notification.id);
    }
  }
}

class _NotificationTile extends StatelessWidget {
  final NotificationItem notification;
  final VoidCallback onTap;
  final VoidCallback? onRead;
  final VoidCallback onDelete;

  const _NotificationTile({
    required this.notification,
    required this.onTap,
    required this.onRead,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      color: notification.isRead
          ? theme.colorScheme.surface
          : theme.colorScheme.primary.withValues(alpha: 0.07),
      child: ListTile(
        onTap: onTap,
        leading: Icon(
          notification.isRead
              ? Icons.notifications_none_rounded
              : Icons.notifications_active_outlined,
          color: notification.isRead
              ? theme.colorScheme.onSurfaceVariant
              : theme.colorScheme.primary,
        ),
        title: Text(
          notification.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: notification.isRead
                ? FontWeight.normal
                : FontWeight.bold,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                notification.body,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              if (notification.createdAt != null) ...[
                const SizedBox(height: 5),
                Text(
                  _formatDate(notification.createdAt!),
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ],
          ),
        ),
        trailing: PopupMenuButton<String>(
          tooltip: 'خيارات الإشعار',
          onSelected: (value) {
            if (value == 'read') onRead?.call();
            if (value == 'delete') onDelete();
          },
          itemBuilder: (context) => [
            if (onRead != null)
              const PopupMenuItem(value: 'read', child: Text('تحديد كمقروء')),
            const PopupMenuItem(value: 'delete', child: Text('حذف')),
          ],
        ),
      ),
    );
  }
}

class _MessageState extends StatelessWidget {
  final IconData icon;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _MessageState({
    required this.icon,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 52, color: theme.colorScheme.primary),
            const SizedBox(height: 14),
            Text(message, textAlign: TextAlign.center),
            if (actionLabel != null) ...[
              const SizedBox(height: 10),
              FilledButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}

String _formatDate(DateTime date) {
  final local = date.toLocal();
  final minute = local.minute.toString().padLeft(2, '0');
  return '${local.day}/${local.month}/${local.year}  ${local.hour}:$minute';
}
