import 'package:flutter/material.dart';
import 'package:sanad/core/helper/responsive_extensions.dart';
import 'package:sanad/core/helper/spacing.dart';
import 'package:sanad/core/theme/app_colors.dart';
import 'package:sanad/core/theme/text_styles.dart';

class AttendanceDetailsCardWidget extends StatelessWidget {
  const AttendanceDetailsCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: context.responsivePadding(all: 16),
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(16.r(context)),
      ),
      child: Column(
        children: [
          // Date Row
          Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                color: AppColors.gray,
                size: 20.r(context),
              ),
              horizontalSpace(context, width: 12),
              Text(
                'الإثنين، 14 مارس 2026',
                style: TextStyles.cairoBold32Dark(
                  context,
                ).copyWith(fontSize: 14.sp(context)),
              ),
            ],
          ),
          verticalSpace(context, height: 16),

          // Time Row
          Row(
            children: [
              Icon(
                Icons.access_time,
                color: AppColors.primaryColor,
                size: 20.r(context),
              ),
              horizontalSpace(context, width: 12),
              Text(
                '10:23 AM',
                style: TextStyles.cairoBold32Dark(context).copyWith(
                  fontSize: 14.sp(context),
                  color: AppColors.primaryColor,
                ),
              ),
            ],
          ),
          verticalSpace(context, height: 16),

          // Info Note Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.info_outline,
                color: AppColors.gray,
                size: 18.r(context),
              ),
              horizontalSpace(context, width: 8),
              Expanded(
                child: Text(
                  'سيتم تسجيل وقت وموقع حضورك بشكل فعلي',
                  style: TextStyles.cairoRegular14Muted(
                    context,
                  ).copyWith(fontSize: 12.sp(context)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
