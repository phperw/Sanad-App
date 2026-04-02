import 'package:flutter/material.dart';
import 'package:sanad/core/constants/app_images.dart';
import 'package:sanad/core/theme/app_colors.dart';
import 'package:sanad/core/theme/text_styles.dart';
import 'package:sanad/core/helper/responsive_extensions.dart';
import 'package:sanad/core/helper/spacing.dart';
import '../../data/models/home_response.dart';

class HeaderSection extends StatelessWidget {
  final Volunteer volunteer;

  const HeaderSection({super.key, required this.volunteer});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 24.r(context),
          backgroundImage: volunteer.avatarUrl != null
              ? NetworkImage(volunteer.avatarUrl!) as ImageProvider
              : const AssetImage(Assets.imageFace),
        ),
        horizontalSpace(context, width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "مرحباً، ${volunteer.fullName.split(' ').first}",
              style: TextStyles.cairoBold16Black(context),
            ),
            Row(
              children: [
                Container(
                  width: 8.w(context),
                  height: 8.w(context),
                  decoration: BoxDecoration(
                    color: volunteer.status == 'ACTIVE'
                        ? AppColors.primaryColor
                        : Colors.grey,
                    shape: BoxShape.circle,
                  ),
                ),
                horizontalSpace(context, width: 6),
                Text(
                  volunteer.status == 'ACTIVE' ? "متصل الآن" : "غير متصل",
                  style: TextStyles.cairoRegular12Gray(context),
                ),
              ],
            ),
          ],
        ),
        const Spacer(),
        Container(
          width: 44.w(context),
          height: 44.w(context),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(12.r(context)),
          ),
          child: Center(
            child: Image.asset(width: 24.w(context), Assets.imageNotifications),
          ),
        ),
      ],
    );
  }
}
