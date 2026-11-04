import 'package:flutter/material.dart';
import 'package:sanad/core/helper/responsive_extensions.dart';
import 'package:sanad/core/helper/spacing.dart';
import 'package:sanad/core/theme/app_colors.dart';
import 'package:sanad/core/theme/text_styles.dart';
import 'mission_card_widget.dart';
import 'package:solar_icons/solar_icons.dart';

class MissionsBottomSheetWidget extends StatelessWidget {
  const MissionsBottomSheetWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        height: context.screenHeight * 0.48,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(28.r(context)),
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
            Container(
              width: 38.w(context),
              height: 4.h(context),
              decoration: BoxDecoration(
                color: Theme.of(context).dividerColor,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            verticalSpace(context, height: 12),
            Padding(
              padding: context.responsivePadding(horizontal: 20),
              child: Row(
                children: [
                  Container(
                    width: 38.r(context),
                    height: 38.r(context),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(13.r(context)),
                    ),
                    child: Icon(
                      SolarIconsOutline.map,
                      color: AppColors.primaryColor,
                      size: 20.r(context),
                    ),
                  ),
                  SizedBox(width: 10.w(context)),
                  Expanded(
                    child: Text(
                      'مهام قريبة منك',
                      style: TextStyles.cairoBold32Dark(
                        context,
                      ).copyWith(fontSize: 17.sp(context)),
                    ),
                  ),
                  Text(
                    '3 مهام',
                    style: TextStyles.cairoRegular14Muted(context).copyWith(
                      color: AppColors.primaryColor,
                      fontSize: 11.sp(context),
                    ),
                  ),
                ],
              ),
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
