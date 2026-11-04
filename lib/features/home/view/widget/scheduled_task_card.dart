import 'package:flutter/material.dart';
import 'package:sanad/core/theme/app_colors.dart';
import 'package:sanad/core/helper/responsive_extensions.dart';
import '../../../../core/helper/spacing.dart';
import 'package:solar_icons/solar_icons.dart';

class ScheduledTaskCard extends StatelessWidget {
  final String title;
  final String time;
  final String remainingTime;
  final String locationName;
  final String taskType;
  final bool isCompleted;
  final VoidCallback? onTap;

  const ScheduledTaskCard({
    super.key,
    this.title = '',
    required this.time,
    required this.remainingTime,
    required this.locationName,
    required this.taskType,
    this.isCompleted = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Material(
      color: theme.cardColor,
      borderRadius: BorderRadius.circular(20.r(context)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: context.responsivePadding(horizontal: 14, vertical: 14),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.borderThemed(context)),
            borderRadius: BorderRadius.circular(20.r(context)),
          ),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Row(
              children: [
                Container(
                  width: 48.r(context),
                  height: 48.r(context),
                  decoration: BoxDecoration(
                    color:
                        (isCompleted
                                ? AppColors.chatChipBorder
                                : AppColors.primaryColor)
                            .withValues(alpha: 0.11),
                    borderRadius: BorderRadius.circular(16.r(context)),
                  ),
                  child: Icon(
                    isCompleted
                        ? SolarIconsOutline.checkCircle
                        : SolarIconsOutline.handHeart,
                    color: isCompleted
                        ? AppColors.chatChipBorder
                        : AppColors.primaryColor,
                    size: 25.r(context),
                  ),
                ),
                SizedBox(width: 12.w(context)),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title.isEmpty ? locationName : title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: theme.colorScheme.onSurface,
                          fontSize: 14.sp(context),
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 3.h(context)),
                      Text(
                        taskType,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.62,
                          ),
                          fontSize: 11.sp(context),
                          fontFamily: 'Cairo',
                        ),
                      ),
                      SizedBox(height: 8.h(context)),
                      Wrap(
                        spacing: 10.w(context),
                        runSpacing: 4.h(context),
                        children: [
                          _detail(
                            context,
                            SolarIconsOutline.mapPoint,
                            locationName,
                          ),
                          _detail(
                            context,
                            SolarIconsOutline.clockCircle,
                            _formatTime(time),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8.w(context)),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 9.w(context),
                        vertical: 5.h(context),
                      ),
                      decoration: BoxDecoration(
                        color:
                            (isCompleted
                                    ? AppColors.chatChipBorder
                                    : AppColors.primaryColor)
                                .withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(20.r(context)),
                      ),
                      child: Text(
                        remainingTime,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: isCompleted
                              ? AppColors.chatChipBorder
                              : AppColors.primaryColor,
                          fontSize: 9.sp(context),
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SizedBox(height: 7.h(context)),
                    Icon(
                      isCompleted
                          ? SolarIconsOutline.checkCircle
                          : SolarIconsOutline.arrowLeft,
                      color: isCompleted
                          ? AppColors.chatChipBorder
                          : theme.colorScheme.onSurface.withValues(alpha: 0.4),
                      size: 17.r(context),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _detail(BuildContext context, IconData icon, String label) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          size: 13.r(context),
          color: theme.colorScheme.onSurface.withValues(alpha: 0.48),
        ),
        SizedBox(width: 3.w(context)),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 105.w(context)),
          child: Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              fontSize: 9.sp(context),
              fontFamily: 'Cairo',
            ),
          ),
        ),
      ],
    );
  }

  String _formatTime(String value) {
    final date = DateTime.tryParse(value);
    if (date == null) return value;
    const months = [
      'يناير',
      'فبراير',
      'مارس',
      'أبريل',
      'مايو',
      'يونيو',
      'يوليو',
      'أغسطس',
      'سبتمبر',
      'أكتوبر',
      'نوفمبر',
      'ديسمبر',
    ];
    return '${date.day} ${months[date.month - 1]}';
  }
}

/// -------------------------
/// اسم الصفحة المقترح: ScheduledTasksPage
/// -------------------------

class ScheduledTasksPage extends StatelessWidget {
  const ScheduledTasksPage({super.key});

  // بيانات تجريبية — استبدلها بالداتا الحقيقية
  static const List<Map<String, String>> _tasks = [
    {
      'time': 'AM 10:00',
      'remaining': 'متبقي 2س',
      'location': 'منطقة أكتوبر السكنية',
      'type': 'مهمة ميدانية سريعة',
    },
    {
      'time': 'PM 2:30',
      'remaining': 'متبقي 6س',
      'location': 'حي المعادي - شارع 9',
      'type': 'دعم لوجستي و توزيع',
    },
    // أضف المزيد حسب الحاجة
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF2F2F2),
      body: ListView.separated(
        padding: context.responsivePadding(horizontal: 16, vertical: 16),
        itemCount: _tasks.length,
        // ignore: unnecessary_underscores
        separatorBuilder: (_, __) => verticalSpace(context, height: 12),
        itemBuilder: (context, index) {
          final task = _tasks[index];
          return ScheduledTaskCard(
            time: task['time']!,
            remainingTime: task['remaining']!,
            locationName: task['location']!,
            taskType: task['type']!,
          );
        },
      ),
    );
  }
}
