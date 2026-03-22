import 'package:flutter/material.dart';
import 'package:sanad/core/helper/responsive_extensions.dart';
import 'package:sanad/core/helper/spacing.dart';
import 'package:sanad/core/theme/app_colors.dart';
import 'package:sanad/core/theme/text_styles.dart';

class NewBadgeCardWidget extends StatelessWidget {
  const NewBadgeCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.responsivePadding(horizontal: 24),
      child: Container(
        padding: context.responsivePadding(all: 16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFFFDE68A),
              Color(0xFFF59E0B),
            ], // Light yellow to Orange gradient
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          borderRadius: BorderRadius.circular(16.r(context)),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFF59E0B).withOpacity(0.3),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // Text on the Right (RTL)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'شارة جديدة! 🎉',
                    style: TextStyles.cairoRegular14Muted(context).copyWith(
                      fontSize: 12.sp(context),
                      color: const Color(0xFF78350F), // Dark brown/orange text
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  verticalSpace(context, height: 4),
                  Text(
                    'بطل التوعية الميدانية',
                    style: TextStyles.cairoBold32Dark(context).copyWith(
                      fontSize: 16.sp(context),
                      color: const Color(0xFF451A03), // Very dark brown
                    ),
                  ),
                ],
              ),
            ),

            // Badge Icon on the Left (RTL)
            Container(
              padding: context.responsivePadding(all: 12),
              decoration: BoxDecoration(
                color: AppColors.white.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.workspace_premium,
                color: AppColors.white,
                size: 32.r(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
