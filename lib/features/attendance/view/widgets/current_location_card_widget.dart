import 'package:flutter/material.dart';
import 'package:sanad/core/helper/responsive_extensions.dart';
import 'package:sanad/core/helper/spacing.dart';
import 'package:sanad/core/theme/app_colors.dart';
import 'package:sanad/core/theme/text_styles.dart';

class CurrentLocationCardWidget extends StatelessWidget {
  const CurrentLocationCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(16.r(context)),
      ),
      child: Column(
        children: [
          // Top Map Image
          ClipRRect(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(16.r(context)),
            ),
            child: Image.asset(
              'assets/images/map_snippet.png', // Don't forget to add this to your assets!
              height: 120.h(context),
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),

          // Bottom Info Area
          Padding(
            padding: context.responsivePadding(all: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment
                      .start, // Acts as Right alignment in RTL
                  children: [
                    Text(
                      'منطقة أكتوبر السكنية',
                      style: TextStyles.cairoBold32Dark(
                        context,
                      ).copyWith(fontSize: 14.sp(context)),
                    ),
                    verticalSpace(context, height: 4),
                    Row(
                      children: [
                        Icon(
                          Icons.check_circle_outline,
                          color: AppColors.primaryColor,
                          size: 16.r(context),
                        ),
                        horizontalSpace(context, width: 4),
                        Text(
                          'أنت داخل النطاق — على بعد 50 متر',
                          style: TextStyles.cairoRegular14Muted(context)
                              .copyWith(
                                fontSize: 12.sp(context),
                                color: AppColors.primaryColor,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
                // Location Icon on the far left
                Container(
                  padding: context.responsivePadding(all: 8),
                  decoration: BoxDecoration(
                    color: const Color(
                      0xFFE4F3EB,
                    ), // Light green background for icon
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.location_on_outlined,
                    color: AppColors.primaryColor,
                    size: 20.r(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
