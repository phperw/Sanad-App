import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/helper/responsive_extensions.dart';

class LeaderboardHeader extends StatelessWidget {
  const LeaderboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'لوحة المتصدرين🏆',
          style: TextStyles.cairoBold16DarkBlue(
            context,
          ).copyWith(fontWeight: FontWeight.w700),
        ),
        GestureDetector(
          onTap: () {},
          child: Text(
            'عرض الكل',
            style: TextStyles.cairoMedium14Black(context).copyWith(
              color: AppColors.chatChipBorder,
              fontSize: 12.sp(context),
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
