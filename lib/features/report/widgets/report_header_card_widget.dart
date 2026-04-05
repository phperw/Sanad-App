import 'package:flutter/material.dart';
import 'package:sanad/core/helper/responsive_extensions.dart';
import 'package:sanad/core/helper/spacing.dart';
import 'package:sanad/core/theme/app_colors.dart';
import 'package:sanad/core/theme/text_styles.dart';

class ReportHeaderCardWidget extends StatelessWidget {
  const ReportHeaderCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cardColor = Theme.of(context).cardColor;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12.r(context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r(context)),
        child: Row(
          children: [
            Container(
              width: 8.w(context),
              height: 80.h(context),
              color: AppColors.primaryColor,
            ),
            Expanded(
              child: Padding(
                padding: context.responsivePadding(all: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'حملة التوعية السكنية - أكتوبر',
                      style: TextStyles.cairoBold32Dark(
                        context,
                      ).copyWith(fontSize: 16.sp(context), color: onSurface),
                    ),
                    verticalSpace(context, height: 8),
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 14.r(context),
                          color: AppColors.gray,
                        ),
                        horizontalSpace(context, width: 4),
                        Text(
                          'منطقة أكتوبر السكنية',
                          style: TextStyles.cairoRegular14Muted(
                            context,
                          ).copyWith(fontSize: 12.sp(context)),
                        ),
                        horizontalSpace(context, width: 12),
                        Icon(
                          Icons.access_time,
                          size: 14.r(context),
                          color: AppColors.gray,
                        ),
                        horizontalSpace(context, width: 4),
                        Text(
                          '10:23 AM',
                          style: TextStyles.cairoRegular14Muted(
                            context,
                          ).copyWith(fontSize: 12.sp(context)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
