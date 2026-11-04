import 'package:flutter/material.dart';
import 'package:sanad/core/theme/app_colors.dart';
import 'package:sanad/core/theme/text_styles.dart';
import 'package:sanad/core/helper/responsive_extensions.dart';
import 'package:solar_icons/solar_icons.dart';

class TasksHeader extends StatelessWidget {
  const TasksHeader({
    super.key,
    required this.tasksCount,
    this.title = 'مهام اليوم',
  });

  final int tasksCount;
  final String title;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isUpcoming = title.contains('قادمة');

    return Row(
      children: [
        Container(
          width: 36.r(context),
          height: 36.r(context),
          decoration: BoxDecoration(
            color: AppColors.primaryColor.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(12.r(context)),
          ),
          child: Icon(
            isUpcoming
                ? SolarIconsOutline.calendarDate
                : SolarIconsOutline.clockCircle,
            color: AppColors.primaryColor,
            size: 19.r(context),
          ),
        ),
        SizedBox(width: 9.w(context)),
        Expanded(
          child: Text(
            title,
            style: TextStyles.cairoBold18Black2(context).copyWith(
              color: theme.colorScheme.onSurface,
              fontSize: 16.sp(context),
            ),
          ),
        ),
        Container(
          height: 32.h(context),
          padding: EdgeInsets.symmetric(horizontal: 11.w(context)),
          decoration: BoxDecoration(
            color: isDark
                ? AppColors.primaryColor.withValues(alpha: 0.16)
                : AppColors.tasksChipBackground,
            borderRadius: BorderRadius.circular(24.r(context)),
          ),
          child: Center(
            child: Text(
              '$tasksCount مهمة',
              style: TextStyles.cairoBold12BlackHeighted(context).copyWith(
                color: isDark
                    ? const Color(0xFF61D59A)
                    : AppColors.primaryColor,
                fontSize: 11.sp(context),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
