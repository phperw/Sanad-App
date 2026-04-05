import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sanad/core/helper/responsive_extensions.dart';
import 'package:sanad/core/helper/spacing.dart';
import 'package:sanad/core/theme/app_colors.dart';
import 'package:sanad/core/theme/text_styles.dart';
import 'package:sanad/core/widgets/app_button.dart';
import '../../../../core/routing/router.dart';
class ConfirmationActionsWidget extends StatelessWidget {
 

  const ConfirmationActionsWidget({
    super.key,
   
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: context.responsivePadding(horizontal: 20, vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppButton(
              text: 'تأكيد الحضور',
              height: 55.h(context),
              borderRadius: 12,
              // ← مفعّل بس لو داخل النطاق
              buttonColor:
                  AppColors.primaryColor,
              
              onPressed: 
                   () => context.push(AppRouter.kSuccessCheckin)
                 
            ),
            verticalSpace(context, height: 12),
            AppButton(
              text: 'إلغاء',
              height: 55.h(context),
              borderRadius: 12,
              buttonColor: AppColors.transparent,
              boxShadow: const [],
              textStyle: TextStyles.cairoBold32Dark(context)
                  .copyWith(fontSize: 16.sp(context), color: AppColors.gray),
              onPressed: () => context.pop(),
            ),
          ],
        ),
      ),
    );
  }
}
