import 'package:flutter/material.dart';
import 'package:sanad/core/helper/responsive_extensions.dart';
import 'package:sanad/core/helper/spacing.dart';
import 'package:sanad/core/theme/app_colors.dart';
import 'package:sanad/core/theme/text_styles.dart';

class SuccessHeaderWidget extends StatelessWidget {
  const SuccessHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Column(
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
            child: Icon(
              Icons.check,
              color: AppColors.white,
              size: 50.r(context),
            ),
          ),
        ),
        verticalSpace(context, height: 24),
        Text(
          'تم تسجيل حضورك!',
          style: TextStyles.cairoBold32Dark(
            context,
          ).copyWith(fontSize: 26.sp(context), color: onSurface),
        ),
        verticalSpace(context, height: 8),
        Text(
          'أحسنت! تم توثيق حضورك في الحملة بنجاح',
          style: TextStyles.cairoRegular14Muted(
            context,
          ).copyWith(fontSize: 14.sp(context)),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
