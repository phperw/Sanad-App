import 'package:flutter/material.dart';
import 'package:sanad/core/helper/responsive_extensions.dart';
import 'package:sanad/core/helper/spacing.dart';
import 'package:sanad/core/theme/app_colors.dart';
import 'package:sanad/core/theme/text_styles.dart';

class SuccessSummaryCardWidget extends StatelessWidget {
  const SuccessSummaryCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: context.responsivePadding(horizontal: 24),
      child: Container(
        padding: context.responsivePadding(all: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          border: Border.all(
            color: isDark ? Colors.grey.shade800 : Colors.grey.shade200,
          ),
          borderRadius: BorderRadius.circular(16.r(context)),
        ),
        child: Column(
          children: [
            _buildSummaryRow(
              context,
              'وقت التسجيل',
              '10:23 AM',
              Icons.access_time,
              isDark,
            ),
            Divider(
              height: 24.h(context),
              color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
              thickness: 1,
            ),
            _buildSummaryRow(
              context,
              'موقع الحملة',
              'منطقة أكتوبر السكنية',
              Icons.location_on_outlined,
              isDark,
            ),
            Divider(
              height: 24.h(context),
              color: isDark ? Colors.grey.shade800 : Colors.grey.shade100,
              thickness: 1,
            ),
            _buildSummaryRow(
              context,
              'نقاط مكتسبة',
              '+50 نقطة',
              Icons.star,
              isDark,
              valueColor: const Color(0xFFF59E0B),
              iconColor: const Color(0xFFF59E0B),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(
    BuildContext context,
    String title,
    String value,
    IconData icon,
    bool isDark, {
    Color? valueColor,
    Color? iconColor,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: iconColor ?? AppColors.primaryColor,
              size: 20.r(context),
            ),
            horizontalSpace(context, width: 8),
            Text(
              title,
              style: TextStyles.cairoRegular14Muted(context).copyWith(
                fontSize: 12.sp(context),
                color: isDark ? Colors.grey.shade400 : null,
              ),
            ),
          ],
        ),
        Text(
          value,
          style: TextStyles.cairoBold32Dark(context).copyWith(
            fontSize: 14.sp(context),
            color: valueColor ?? (isDark ? Colors.white : AppColors.dark),
          ),
        ),
      ],
    );
  }
}
