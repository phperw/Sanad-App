import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sanad/core/helper/responsive_extensions.dart';
import 'package:sanad/core/helper/spacing.dart';
import 'package:sanad/core/theme/app_colors.dart';
import 'package:sanad/core/theme/text_styles.dart';
import 'package:sanad/core/widgets/app_button.dart';
import '../../../core/routing/router.dart';

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
    return Container(
      margin: context.responsivePadding(bottom: 12),
      padding: context.responsivePadding(all: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16.r(context)),
        border: Border.all(color: Colors.grey.shade100, width: 2),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyles.cairoBold32Dark(
                    context,
                  ).copyWith(fontSize: 14.sp(context)),
                ),
                verticalSpace(context, height: 4),
                Row(
                  children: [
                    Icon(
                      Icons.location_on_outlined,
                      size: 14.r(context),
                      color: AppColors.gray,
                    ),
                    horizontalSpace(context, width: 4),
                    Text(
                      distance,
                      style: TextStyles.cairoRegular14Muted(
                        context,
                      ).copyWith(fontSize: 12.sp(context)),
                    ),
                  ],
                ),
              ],
            ),
          ),
          AppButton(
            text: 'تسجيل الحضور',
            width: 110.w(context),
            height: 38.h(context),
            borderRadius: 8,
            buttonColor: isActive
                ? AppColors.primaryColor
                : Colors.grey.shade200,
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
