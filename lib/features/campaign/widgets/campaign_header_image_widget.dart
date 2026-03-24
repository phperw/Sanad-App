import 'package:flutter/material.dart';
import 'package:sanad/core/helper/responsive_extensions.dart';
import 'package:sanad/core/helper/spacing.dart';
import 'package:sanad/core/theme/app_colors.dart';
import 'package:sanad/core/theme/text_styles.dart';

class CampaignHeaderImageWidget extends StatelessWidget {
  const CampaignHeaderImageWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          height: 250.h(context),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(24.r(context)),
              bottomRight: Radius.circular(24.r(context)),
            ),
            image: const DecorationImage(
              image: AssetImage('assets/images/map_header.png'),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: context.responsivePadding(horizontal: 16, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 40.w(context)),
                Text(
                  'التفاصيل',
                  style: TextStyles.cairoBold32Dark(context).copyWith(
                    fontSize: 18.sp(context),
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: EdgeInsets.all(8.r(context)),
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
        Positioned(
          bottom: -15.h(context),
          right: 20.w(context),
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
                  style: TextStyles.cairoBold12Black(context).copyWith(
                    color: AppColors.white,
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