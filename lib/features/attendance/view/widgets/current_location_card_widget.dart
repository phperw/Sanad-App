import 'package:flutter/material.dart';
import 'package:sanad/core/helper/responsive_extensions.dart';
import 'package:sanad/core/helper/spacing.dart';
import 'package:sanad/core/theme/app_colors.dart';
import 'package:sanad/core/theme/text_styles.dart';
import '../../../../core/constants/app_images.dart';

class CurrentLocationCardWidget extends StatelessWidget {
  const CurrentLocationCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cardColor = Theme.of(context).cardColor;
    final dividerColor = Theme.of(context).dividerColor;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        border: Border.all(color: dividerColor),
        borderRadius: BorderRadius.circular(16.r(context)),
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(16.r(context)),
            ),
            child: Image.asset(
              Assets.mapTest,
              height: 120.h(context),
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: context.responsivePadding(all: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'موقعك الحالي',
                      style: TextStyles.cairoBold32Dark(
                        context,
                      ).copyWith(fontSize: 14.sp(context), color: onSurface),
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
                Container(
                  padding: context.responsivePadding(all: 8),
                  decoration: const BoxDecoration(
                    color: AppColors.lightGreenishWhite,
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
