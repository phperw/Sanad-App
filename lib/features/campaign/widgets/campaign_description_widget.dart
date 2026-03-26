import 'package:flutter/material.dart';
import 'package:sanad/core/helper/responsive_extensions.dart';
import 'package:sanad/core/helper/spacing.dart';
import 'package:sanad/core/theme/text_styles.dart';

class CampaignDescriptionWidget extends StatelessWidget {
  const CampaignDescriptionWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.responsivePadding(horizontal: 20, top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'وصف المهمة',
            style: TextStyles.cairoRegular14Muted(
              context,
            ).copyWith(fontSize: 12.sp(context)),
          ),
          verticalSpace(context, height: 8),
          Text(
            'توزيع مطبوعات توعوية على السكان وإجراء جلسات تعريفية بمخاطر الإدمان في المنطقة السكنية. يُرجى الالتزام بالزي الرسمي للصندوق.',
            style: TextStyles.cairoRegular14Black(
              context,
            ).copyWith(fontSize: 14.sp(context), height: 1.6),
          ),
          verticalSpace(context, height: 24),
        ],
      ),
    );
  }
}
