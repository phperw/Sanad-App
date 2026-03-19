import 'package:flutter/material.dart';
import 'package:sanad/core/helper/responsive_extensions.dart';
import 'package:sanad/core/helper/spacing.dart';
import 'package:sanad/core/theme/app_colors.dart';
import 'package:sanad/core/theme/text_styles.dart';

class ReportSuccessHeaderWidget extends StatelessWidget {
  const ReportSuccessHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.responsivePadding(horizontal: 20),
      child: Column(
        children: [
          Container(
            height: 100.r(context),
            width: 100.r(context),
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryColor.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Center(
              // Paper plane icon for "Sent"
              child: Icon(
                Icons.send_rounded,
                color: AppColors.white,
                size: 45.r(context),
              ),
            ),
          ),
          verticalSpace(context, height: 24),

          Text(
            'تم إرسال التقرير!',
            style: TextStyles.cairoBold32Dark(
              context,
            ).copyWith(fontSize: 26.sp(context)),
          ),
          verticalSpace(context, height: 8),
          Text(
            'شكراً! تم توثيق تقريرك بنجاح وسيتم مراجعته من الإدارة',
            style: TextStyles.cairoRegular14Muted(
              context,
            ).copyWith(fontSize: 14.sp(context)),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
