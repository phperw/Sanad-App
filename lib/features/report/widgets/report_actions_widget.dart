import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sanad/core/helper/responsive_extensions.dart';
import 'package:sanad/core/helper/spacing.dart';
import 'package:sanad/core/theme/app_colors.dart';
import 'package:sanad/core/theme/text_styles.dart';
import 'package:sanad/core/widgets/app_button.dart';
import '../../../core/routing/router.dart';

class ReportActionsWidget extends StatelessWidget {
  const ReportActionsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppButton(
          text: 'إرسال التقرير',
          height: 55.h(context),
          borderRadius: 12,
          onPressed: () {
            context.push(AppRouter.kReportSuccess);
          },
        ),
        verticalSpace(context, height: 12),
        AppButton(
          text: 'حفظ كمسودة',
          height: 55.h(context),
          borderRadius: 12,
          buttonColor: Colors.transparent,
          boxShadow: const [],
          textStyle: TextStyles.cairoBold32Dark(
            context,
          ).copyWith(fontSize: 16.sp(context), color: AppColors.primaryColor),
          onPressed: () {
            // save as draft logic
          },
        ),
      ],
    );
  }
}
