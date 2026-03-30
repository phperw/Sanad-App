import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/helper/responsive_extensions.dart';

class ActiveVolunteerBadgeWidget extends StatelessWidget {
  final String label;

  const ActiveVolunteerBadgeWidget({super.key, this.label = 'متطوع نشط 🌟'});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: 16.w(context),
        vertical: 8.h(context),
      ),
      decoration: ShapeDecoration(
        color: AppColors.lightGreenishWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100.r(context)),
        ),
      ),
      child: Text(
        label,
        style: TextStyles.cairoSemiBold12Primary(
          context,
        ).copyWith(fontSize: 13.sp(context), height: 1.50),
      ),
    );
  }
}
