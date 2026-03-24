import 'package:flutter/material.dart';
import 'package:sanad/core/helper/responsive_extensions.dart';
import 'package:sanad/core/helper/spacing.dart';
import 'package:sanad/core/theme/app_colors.dart';
import 'package:sanad/core/theme/text_styles.dart';
import 'mission_card_widget.dart';

class MissionsBottomSheetWidget extends StatelessWidget {
  const MissionsBottomSheetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: context.screenHeight * 0.45, // Responsive height
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.white, // Matching the UI background
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.r(context)),
            topRight: Radius.circular(24.r(context)),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          children: [
            verticalSpace(context, height: 20),
            // Header Title
            Text(
              'المهام الميدانية',
              style: TextStyles.cairoBold32Dark(
                context,
              ).copyWith(fontSize: 18.sp(context)),
            ),
            verticalSpace(context, height: 16),

            // Scrollable List of Missions
            Expanded(
              child: ListView(
                padding: context.responsivePadding(horizontal: 16),
                children: const [
                  MissionCardWidget(
                    title: 'منطقة أكتوبر السكنية',
                    distance: 'على بعد 50 متر',
                    isActive: true,
                  ),
                  MissionCardWidget(
                    title: 'حي المعادي - شارع 9',
                    distance: 'على بعد 15 كم',
                    isActive: false,
                  ),
                  MissionCardWidget(
                    title: 'مصر الجديدة',
                    distance: 'على بعد 40 كم',
                    isActive: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
