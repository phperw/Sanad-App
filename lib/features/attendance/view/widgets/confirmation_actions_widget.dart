import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // <-- 1. Make sure this is imported!
import 'package:sanad/core/helper/responsive_extensions.dart';
import 'package:sanad/core/helper/spacing.dart';
import 'package:sanad/core/theme/app_colors.dart';
import 'package:sanad/core/theme/text_styles.dart';

class ConfirmationActionsWidget extends StatelessWidget {
  const ConfirmationActionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: context.responsivePadding(horizontal: 20, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
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
                  // 2. THIS IS THE FIX! Tell it to go to the success screen.
                  // We use pushReplacement so they can't swipe back to the confirm screen again.
                  context.pushReplacement('/successCheckin');
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'تأكيد الحضور',
                      style: TextStyles.cairoExtraBold18White(context),
                    ),
                    horizontalSpace(context, width: 8),
                    Icon(
                      Icons.check_circle_outline,
                      color: AppColors.white,
                      size: 20.r(context),
                    ),
                  ],
                ),
              ),
            ),
            verticalSpace(context, height: 12),
            SizedBox(
              width: double.infinity,
              height: 55.h(context),
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.grey.shade300),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r(context)),
                  ),
                ),
                onPressed: () => context.pop(),
                child: Text(
                  'إلغاء',
                  style: TextStyles.cairoBold32Dark(
                    context,
                  ).copyWith(fontSize: 16.sp(context), color: AppColors.gray),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
