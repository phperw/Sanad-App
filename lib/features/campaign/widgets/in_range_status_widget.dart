import 'package:flutter/material.dart';
import 'package:sanad/core/helper/responsive_extensions.dart';
import 'package:sanad/core/helper/spacing.dart';
import 'package:sanad/core/theme/app_colors.dart';

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
          color: const Color(0xFFE4F3EB), // The light green from the design
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
                  style: TextStyle(
                    color: AppColors.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14.sp(context),
                    fontFamily: 'Cairo',
                  ),
                ),
                Text(
                  'يمكنك تسجيل حضورك الآن',
                  style: TextStyle(
                    color: AppColors.gray,
                    fontSize: 12.sp(context),
                    fontFamily: 'Cairo',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
