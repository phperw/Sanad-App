import 'package:flutter/material.dart';
import 'package:sanad/core/helper/responsive_extensions.dart';
import 'package:sanad/core/helper/spacing.dart';
import 'package:sanad/core/theme/app_colors.dart';
import 'package:sanad/core/theme/text_styles.dart';

class CampaignInfoWidget extends StatelessWidget {
  const CampaignInfoWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: context.responsivePadding(
        horizontal: 20,
        top: 32,
      ), // Top padding accounts for the overlapping tag
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'اسم الحملة',
            style: TextStyles.cairoRegular14Muted(
              context,
            ).copyWith(fontSize: 12.sp(context)),
          ),
          Text(
            'حملة التوعية السكنية - أكتوبر',
            style: TextStyles.cairoBold32Dark(
              context,
            ).copyWith(fontSize: 20.sp(context)),
          ),
          verticalSpace(context, height: 20),

          // Location Row
          _buildInfoRow(
            context,
            Icons.location_on_outlined,
            'منطقة أكتوبر السكنية، شارع 5',
          ),
          verticalSpace(context, height: 16),

          // Date and Time Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoRow(
                context,
                Icons.calendar_today_outlined,
                'الإثنين، 14 مارس 2026',
              ),
              _buildInfoRow(
                context,
                Icons.access_time,
                '10:00 AM - 12:00 PM',
                iconColor: AppColors.primaryColor,
              ),
            ],
          ),
          verticalSpace(context, height: 16),

          // Volunteers Row
          _buildInfoRow(
            context,
            Icons.people_outline,
            '8 متطوعين مسجلين',
            textColor: AppColors.dark,
            isBold: true,
          ),

          verticalSpace(context, height: 24),
          Divider(color: Colors.grey.shade200, thickness: 1),
        ],
      ),
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    IconData icon,
    String text, {
    Color? iconColor,
    Color? textColor,
    bool isBold = false,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          icon,
          color: iconColor ?? AppColors.primaryColor,
          size: 20.r(context),
        ),
        horizontalSpace(context, width: 8),
        Text(
          text,
          style: TextStyle(
            fontSize: 13.sp(context),
            color: textColor ?? AppColors.dark,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
            fontFamily: 'Cairo',
          ),
        ),
      ],
    );
  }
}
