import 'package:flutter/material.dart';
import 'package:sanad/core/helper/responsive_extensions.dart';
import 'package:sanad/core/helper/spacing.dart';
import 'package:sanad/core/theme/app_colors.dart';
import 'package:sanad/core/theme/text_styles.dart';

class CampaignRatingWidget extends StatefulWidget {
  const CampaignRatingWidget({super.key});

  @override
  State<CampaignRatingWidget> createState() => _CampaignRatingWidgetState();
}

class _CampaignRatingWidgetState extends State<CampaignRatingWidget> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final cardColor = Theme.of(context).cardColor;
    final dividerColor = Theme.of(context).dividerColor;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Column(
      children: [
        Text(
          'كيف سارت الحملة؟',
          style: TextStyles.cairoBold32Dark(
            context,
          ).copyWith(fontSize: 16.sp(context), color: onSurface),
        ),
        verticalSpace(context, height: 16),
        Container(
          padding: context.responsivePadding(vertical: 16, horizontal: 8),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16.r(context)),
            border: Border.all(color: dividerColor),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildRatingOption(
                context,
                title: 'ممتازة',
                emoji: '🌟',
                index: 0,
              ),
              _buildRatingOption(context, title: 'جيدة', emoji: '👍', index: 1),
              _buildRatingOption(context, title: 'صعبة', emoji: '😓', index: 2),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRatingOption(
    BuildContext context, {
    required String title,
    required String emoji,
    required int index,
  }) {
    final cardColor = Theme.of(context).cardColor;
    bool isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () => setState(() => selectedIndex = index),
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            height: 65.r(context),
            width: 65.r(context),
            decoration: BoxDecoration(
              color: cardColor,
              shape: BoxShape.circle,
              border: isSelected
                  ? Border.all(color: AppColors.primaryColor, width: 2)
                  : Border.all(color: Colors.transparent),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppColors.primaryColor.withOpacity(0.15),
                        blurRadius: 15,
                        spreadRadius: 2,
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 5,
                      ),
                    ],
            ),
            child: Center(
              child: Text(emoji, style: TextStyle(fontSize: 28.sp(context))),
            ),
          ),
          verticalSpace(context, height: 8),
          Text(
            title,
            style: TextStyles.cairoBold32Dark(context).copyWith(
              fontSize: 14.sp(context),
              color: isSelected ? AppColors.primaryColor : AppColors.gray,
            ),
          ),
        ],
      ),
    );
  }
}
