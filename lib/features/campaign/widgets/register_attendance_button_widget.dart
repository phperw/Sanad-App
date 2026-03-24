import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sanad/core/helper/responsive_extensions.dart';
import 'package:sanad/core/widgets/app_button.dart';
import '../../../core/routing/router.dart';

class RegisterAttendanceButtonWidget extends StatelessWidget {
  const RegisterAttendanceButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: context.responsivePadding(horizontal: 20, vertical: 16),
        child: AppButton(
          text: 'تسجيل الحضور',
          height: 55.h(context),
          borderRadius: 12,
          onPressed: () {
            context.push(AppRouter.kAttendanceConfirmation);
          },
        ),
      ),
    );
  }
}
