import 'package:flutter/material.dart';
import 'package:sanad/core/theme/app_colors.dart';
import 'package:sanad/core/theme/text_styles.dart';
import 'package:sanad/core/helper/responsive_extensions.dart';

class StatCard extends StatelessWidget {
  const StatCard({
    super.key,
    required this.title,
    required this.value,
    required this.valueStyle,
    required this.icon,
    required this.accentColor,
  });

  final String title;
  final String value;
  final TextStyle valueStyle;
  final IconData icon;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: context.responsivePadding(horizontal: 14, vertical: 14),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(18.r(context)),
        border: Border.all(color: AppColors.borderThemed(context)),
      ),
      child: Row(
        children: [
          Container(
            width: 42.r(context),
            height: 42.r(context),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.11),
              borderRadius: BorderRadius.circular(14.r(context)),
            ),
            child: Icon(icon, color: accentColor, size: 22.r(context)),
          ),
          SizedBox(width: 10.w(context)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.cairoRegular12Gray(context).copyWith(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.65),
                    fontSize: 11.sp(context),
                  ),
                ),
                Text(
                  value,
                  style: valueStyle.copyWith(
                    fontSize: 22.sp(context),
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
