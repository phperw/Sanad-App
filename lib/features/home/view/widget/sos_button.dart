import 'package:flutter/material.dart';
import 'package:sanad/core/theme/app_colors.dart';
import 'package:sanad/core/theme/text_styles.dart';
import 'package:sanad/core/helper/responsive_extensions.dart';
import 'package:sanad/core/helper/spacing.dart';
import 'package:solar_icons/solar_icons.dart';

class SOSButton extends StatelessWidget {
  const SOSButton({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: isDark ? const Color(0xFF351D26) : const Color(0xFFFFF1F1),
      borderRadius: BorderRadius.circular(18.r(context)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18.r(context)),
        child: Container(
          width: double.infinity,
          padding: context.responsivePadding(horizontal: 15, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18.r(context)),
            border: Border.all(
              color: AppColors.sosRed.withValues(alpha: isDark ? 0.35 : 0.16),
            ),
          ),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Row(
              children: [
                Container(
                  width: 42.r(context),
                  height: 42.r(context),
                  decoration: BoxDecoration(
                    color: AppColors.sosRed.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14.r(context)),
                  ),
                  child: Icon(
                    SolarIconsOutline.dangerTriangle,
                    color: AppColors.sosRed,
                    size: 23.r(context),
                  ),
                ),
                horizontalSpace(context, width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'طوارئ - SOS',
                        style: TextStyles.cairoBold16Black(context).copyWith(
                          color: isDark
                              ? const Color(0xFFFFA0A0)
                              : AppColors.sosRed,
                          fontSize: 14.sp(context),
                        ),
                      ),
                      Text(
                        'اطلب المساعدة عند الحاجة',
                        style: TextStyles.cairoRegular12Gray(context).copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withValues(alpha: 0.62),
                          fontSize: 10.sp(context),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  SolarIconsOutline.arrowLeft,
                  color: AppColors.sosRed.withValues(alpha: 0.8),
                  size: 18.r(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
