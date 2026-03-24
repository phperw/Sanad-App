import 'package:flutter/material.dart';
import 'package:sanad/core/helper/responsive_extensions.dart';
import 'package:sanad/core/helper/spacing.dart';
import 'package:sanad/core/theme/app_colors.dart';
import 'package:sanad/core/theme/text_styles.dart';

class InRangeStatusWidget extends StatelessWidget {
  const InRangeStatusWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.responsivePadding(horizontal: 20),
      child: Container(
        width: double.infinity,
        padding: context.responsivePadding(all: 16),
        decoration: BoxDecoration(
          color: AppColors.lightGreenishWhite,
          borderRadius: BorderRadius.circular(12.r(context)),
        ),
        child: Row(
          children: [
            Container(
              padding: context.responsivePadding(all: 4),
              decoration: const BoxDecoration(
                color: AppColors.primaryColor,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check,
                color: AppColors.white,
                size: 20.r(context),
              ),
            ),
            horizontalSpace(context, width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'أنت داخل نطاق الحملة',
                  style: TextStyles.cairoBold14Primary(context),
                ),
                Text(
                  'يمكنك تسجيل حضورك الآن',
                  style: TextStyles.cairoRegular12Gray(context),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}