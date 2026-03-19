import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart'; // <-- 1. Don't forget this import!
import 'package:sanad/core/helper/responsive_extensions.dart';
import 'package:sanad/core/theme/app_colors.dart';
import 'package:sanad/core/theme/text_styles.dart';

class RegisterAttendanceButtonWidget extends StatelessWidget {
  const RegisterAttendanceButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: context.responsivePadding(horizontal: 20, vertical: 16),
        child: SizedBox(
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
              // 2. FIXED: Tell the router to push the new screen!
              context.push('/attendanceConfirmation');
            },
            child: Text(
              'تسجيل الحضور',
              style: TextStyles.cairoExtraBold18White(context),
            ),
          ),
        ),
      ),
    );
  }
}
