import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';

class MemberSinceWidget extends StatelessWidget {
  final String date;

  const MemberSinceWidget({super.key, this.date = 'عضو منذ يناير 2026'});

  @override
  Widget build(BuildContext context) {
    return Text(
      date,
      style: TextStyles.cairoRegular12Gray(
        context,
      ).copyWith(color: AppColors.textGray, height: 1.50),
    );
  }
}
