import 'package:flutter/material.dart';
import 'package:sanad/core/constants/app_images.dart';
import 'package:sanad/core/theme/app_colors.dart';
import 'package:sanad/core/theme/text_styles.dart';
import 'package:sanad/core/helper/responsive_extensions.dart';
import 'package:solar_icons/solar_icons.dart';
import '../../data/models/home_response.dart';

class HeaderSection extends StatelessWidget {
  final Volunteer volunteer;

  const HeaderSection({super.key, required this.volunteer});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final name = volunteer.fullName.trim().split(' ').first;

    return Container(
      padding: context.responsivePadding(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(22.r(context)),
        border: Border.all(color: AppColors.borderThemed(context)),
      ),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(3.r(context)),
              decoration: const BoxDecoration(
                color: AppColors.primaryColor,
                shape: BoxShape.circle,
              ),
              child: CircleAvatar(
                radius: 23.r(context),
                backgroundColor: theme.scaffoldBackgroundColor,
                backgroundImage: volunteer.avatarUrl != null
                    ? NetworkImage(volunteer.avatarUrl!)
                    : const AssetImage(Assets.imageFace),
              ),
            ),
            SizedBox(width: 12.w(context)),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'أهلاً، $name 👋',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyles.cairoBold16Black(
                      context,
                    ).copyWith(fontSize: 16.sp(context)),
                  ),
                  SizedBox(height: 3.h(context)),
                  Row(
                    children: [
                      Container(
                        width: 7.w(context),
                        height: 7.w(context),
                        decoration: BoxDecoration(
                          color: volunteer.status == 'ACTIVE'
                              ? AppColors.primaryColor
                              : AppColors.secondaryGray,
                          shape: BoxShape.circle,
                        ),
                      ),
                      SizedBox(width: 6.w(context)),
                      Text(
                        volunteer.status == 'ACTIVE'
                            ? 'جاهز لصناعة أثر؟'
                            : 'غير متصل',
                        style: TextStyles.cairoRegular12Gray(context).copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.62,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 10.w(context)),
            Material(
              color: AppColors.primaryColor.withValues(alpha: 0.10),
              shape: const CircleBorder(),
              child: InkWell(
                customBorder: const CircleBorder(),
                onTap: () {},
                child: SizedBox(
                  width: 44.r(context),
                  height: 44.r(context),
                  child: Icon(
                    SolarIconsOutline.bell,
                    color: AppColors.primaryColor,
                    size: 22.r(context),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
