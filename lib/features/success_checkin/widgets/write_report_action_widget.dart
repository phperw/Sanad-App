import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sanad/core/helper/responsive_extensions.dart';
import 'package:sanad/core/helper/spacing.dart';
import 'package:sanad/core/theme/app_colors.dart';
import 'package:sanad/core/theme/text_styles.dart';

class WriteReportActionWidget extends StatelessWidget {
  const WriteReportActionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'سيتم الانتقال لكتابة التقرير خلال ثوان',
          style: TextStyles.cairoRegular14Muted(
            context,
          ).copyWith(fontSize: 12.sp(context)),
        ),
        verticalSpace(context, height: 12),

        // Progress Bar Line
        Container(
          height: 3.h(context),
          width: 160.w(context),
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(10.r(context)),
          ),
        ),

        verticalSpace(context, height: 20),

        // Manual Navigation Button
        TextButton(
          onPressed: () {
            // Routes directly to the Report Form we built!
            context.pushReplacement('/campaignReport');
          },
          child: Text(
            'ابدأ كتابة التقرير الآن',
            style: TextStyles.cairoBold32Dark(
              context,
            ).copyWith(fontSize: 16.sp(context), color: AppColors.primaryColor),
          ),
        ),
      ],
    );
  }
}
