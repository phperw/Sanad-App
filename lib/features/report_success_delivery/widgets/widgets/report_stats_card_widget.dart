import 'package:flutter/material.dart';
import 'package:sanad/core/helper/responsive_extensions.dart';
import 'package:sanad/core/helper/spacing.dart';
import 'package:sanad/core/theme/app_colors.dart';
import 'package:sanad/core/theme/text_styles.dart';

class ReportStatsCardWidget extends StatelessWidget {
  const ReportStatsCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cardColor = Theme.of(context).cardColor;
    final dividerColor = Theme.of(context).dividerColor;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Padding(
      padding: context.responsivePadding(horizontal: 24),
      child: Container(
        padding: context.responsivePadding(all: 16),
        decoration: BoxDecoration(
          color: cardColor,
          border: Border.all(color: dividerColor),
          borderRadius: BorderRadius.circular(16.r(context)),
        ),
        child: Column(
          children: [
            _buildStatRow(
              context,
              onSurface,
              'نقاط مكتسبة',
              '+50 نقطة',
              Icons.star,
              const Color(0xFFF59E0B),
            ),
            Divider(height: 24.h(context), color: dividerColor, thickness: 1),
            _buildStatRow(
              context,
              onSurface,
              'ساعات مضافة',
              '+2 ساعة',
              Icons.access_time,
              AppColors.primaryColor,
            ),
            Divider(height: 24.h(context), color: dividerColor, thickness: 1),
            _buildStatRow(
              context,
              onSurface,
              'إجمالي نقاطك',
              '470 نقطة',
              Icons.emoji_events_outlined,
              onSurface,
              isBold: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatRow(
    BuildContext context,
    Color onSurface,
    String title,
    String value,
    IconData icon,
    Color color, {
    bool isBold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, color: color, size: 20.r(context)),
            horizontalSpace(context, width: 8),
            Text(
              title,
              style: TextStyles.cairoRegular14Muted(
                context,
              ).copyWith(fontSize: 12.sp(context)),
            ),
          ],
        ),
        Text(
          value,
          style: TextStyles.cairoBold32Dark(context).copyWith(
            fontSize: 14.sp(context),
            color: color,
            fontWeight: isBold ? FontWeight.w900 : FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
