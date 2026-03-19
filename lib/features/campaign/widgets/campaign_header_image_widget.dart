import 'package:flutter/material.dart';
import 'package:sanad/core/helper/responsive_extensions.dart';
import 'package:sanad/core/helper/spacing.dart';
import 'package:sanad/core/theme/app_colors.dart';

class CampaignHeaderImageWidget extends StatelessWidget {
  const CampaignHeaderImageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior:
          Clip.none, // Allows the green tag to overlap the bottom edge
      children: [
        // The Map Image Background
        Container(
          height: 250.h(context),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(24.r(context)),
              bottomRight: Radius.circular(24.r(context)),
            ),
            image: const DecorationImage(
              image: AssetImage(
                'assets/images/map_header.png',
              ), // Replace with your asset
              fit: BoxFit.cover,
            ),
          ),
        ),

        // Custom Back Button & Title Area
        SafeArea(
          child: Padding(
            padding: context.responsivePadding(horizontal: 16, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Empty box to balance the row for center alignment
                SizedBox(width: 40.w(context)),
                Text(
                  'تفاصيل الحملة',
                  style: TextStyle(
                    fontSize: 18.sp(context),
                    fontWeight: FontWeight.bold,
                    color: AppColors.dark,
                    fontFamily: 'Cairo',
                  ),
                ),
                // Back Button (RTL arrow)
                InkWell(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    height: 40.r(context),
                    width: 40.r(context),
                    decoration: const BoxDecoration(
                      color: AppColors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Icon(
                        Icons.arrow_forward_ios,
                        size: 18.r(context),
                        color: AppColors.dark,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Floating Tag at the bottom right of the image
        Positioned(
          bottom: -15.h(context),
          right: 20.w(context), // Right side for RTL
          child: Container(
            padding: context.responsivePadding(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(20.r(context)),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.campaign_outlined,
                  color: AppColors.white,
                  size: 16.r(context),
                ),
                horizontalSpace(context, width: 4),
                Text(
                  'مهمة ميدانية',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 12.sp(context),
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
