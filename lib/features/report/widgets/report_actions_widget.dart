import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sanad/core/helper/responsive_extensions.dart';
import 'package:sanad/core/helper/spacing.dart';
import 'package:sanad/core/theme/app_colors.dart';
import 'package:sanad/core/theme/text_styles.dart';

class ReportActionsWidget extends StatelessWidget {
  const ReportActionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Primary Submit Button
        SizedBox(
          width: double.infinity,
          height: 55.h(context),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r(context)),
              ),
              elevation: 4,
              shadowColor: AppColors.buttonShadow,
            ),
            onPressed: () {
              context.pushReplacement('/reportSuccess');
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'إرسال التقرير',
                  style: TextStyles.cairoExtraBold18White(context),
                ),
                horizontalSpace(context, width: 8),
                Icon(
                  Icons.send_outlined,
                  color: AppColors.white,
                  size: 20.r(context),
                ), // Icon matches UI
              ],
            ),
          ),
        ),
        verticalSpace(context, height: 12),

        // Secondary Draft Button
        SizedBox(
          width: double.infinity,
          height: 55.h(context),
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              side: BorderSide(
                color: Colors.grey.shade300,
                width: 2,
              ), // Slightly thicker grey border
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r(context)),
              ),
            ),
            onPressed: () {
              //save as draft and navigate to drafts page
            },
            child: Text(
              'حفظ كمسودة',
              style: TextStyles.cairoBold32Dark(context).copyWith(
                fontSize: 16.sp(context),
                color: AppColors.primaryColor,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
