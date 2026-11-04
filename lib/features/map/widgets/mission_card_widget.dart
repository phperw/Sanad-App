import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sanad/core/helper/responsive_extensions.dart';
import 'package:sanad/core/helper/spacing.dart';
import 'package:sanad/core/theme/app_colors.dart';
import 'package:sanad/core/theme/text_styles.dart';
import 'package:sanad/core/widgets/app_button.dart';
import '../../../core/routing/router.dart';
import 'package:solar_icons/solar_icons.dart';

class MissionCardWidget extends StatelessWidget {
  final String title;
  final String distance;
  final bool isActive;

  const MissionCardWidget({
    super.key,
    required this.title,
    required this.distance,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: context.responsivePadding(bottom: 10),
      padding: context.responsivePadding(horizontal: 14, vertical: 13),
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
              color: AppColors.primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(13.r(context)),
            ),
            child: Icon(
              SolarIconsOutline.handHeart,
              color: AppColors.primaryColor,
              size: 22.r(context),
            ),
          ),
          SizedBox(width: 11.w(context)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.cairoBold32Dark(
                    context,
                  ).copyWith(fontSize: 13.sp(context)),
                ),
                SizedBox(height: 3.h(context)),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Icon(
                      SolarIconsOutline.mapPoint,
                      size: 14.r(context),
                      color: AppColors.gray,
                    ),
                    horizontalSpace(context, width: 4),
                    Text(
                      distance,
                      style: TextStyles.cairoRegular14Muted(context).copyWith(
                        fontSize: 10.sp(context),
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.62,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          AppButton(
            text: 'تسجيل الحضور',
            width: 90.w(context),
            height: 38.h(context),
            borderRadius: 14,
            buttonColor: isActive
                ? AppColors.primaryColor
                : theme.disabledColor,
            textStyle: TextStyle(
              color: isActive ? AppColors.white : AppColors.gray,
              fontSize: 12.sp(context),
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
            ),
            boxShadow: const [],
            onPressed: isActive
                ? () => context.push(AppRouter.kAttendanceConfirmation)
                : () {},
          ),
        ],
      ),
    );
  }
}
