import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sanad/core/helper/responsive_extensions.dart';
import 'package:sanad/core/helper/spacing.dart';
import 'package:sanad/core/theme/app_colors.dart';
import 'package:sanad/core/theme/text_styles.dart';
import '../../../../core/routing/router.dart';

class ReturnHomeActionWidget extends StatelessWidget {
  const ReturnHomeActionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'سيتم الانتقال للرئيسية خلال ثوان',
          style: TextStyles.cairoRegular14Muted(
            context,
          ).copyWith(fontSize: 12.sp(context)),
        ),
        verticalSpace(context, height: 12),

        Container(
          height: 3.h(context),
          width: 160.w(context),
          decoration: BoxDecoration(
            color: AppColors.primaryColor,
            borderRadius: BorderRadius.circular(10.r(context)),
          ),
        ),

        verticalSpace(context, height: 20),

        // Return Home Button
        TextButton(
          onPressed: () {
            context.go(AppRouter.kmap);
          },
          child: Text(
            'العودة للرئيسية الآن',
            style: TextStyles.cairoBold32Dark(
              context,
            ).copyWith(fontSize: 16.sp(context), color: AppColors.primaryColor),
          ),
        ),
      ],
    );
  }
}
