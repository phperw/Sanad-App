import 'package:flutter/material.dart';
import 'package:sanad/core/theme/app_colors.dart';
import 'package:sanad/core/theme/text_styles.dart';
import 'package:sanad/core/constants/app_images.dart';
import 'package:sanad/core/helper/responsive_extensions.dart';
import 'package:sanad/core/helper/spacing.dart';
import 'package:solar_icons/solar_icons.dart';
import '../../data/models/home_response.dart';
import 'empty_state_widget.dart';

class NewsSection extends StatelessWidget {
  final List<Announcement> announcements;

  const NewsSection({super.key, required this.announcements});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 36.r(context),
              height: 36.r(context),
              decoration: BoxDecoration(
                color: AppColors.primaryColor.withValues(alpha: 0.11),
                borderRadius: BorderRadius.circular(12.r(context)),
              ),
              child: Icon(
                SolarIconsOutline.bellBing,
                color: AppColors.primaryColor,
                size: 19.r(context),
              ),
            ),
            horizontalSpace(context, width: 9),
            Expanded(
              child: Text(
                'آخر الأخبار والتنبيهات',
                style: TextStyles.cairoBold18Black2(context).copyWith(
                  color: theme.colorScheme.onSurface,
                  fontSize: 16.sp(context),
                ),
              ),
            ),
            if (announcements.isNotEmpty)
              TextButton(
                onPressed: () {},
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primaryColor,
                  padding: EdgeInsets.zero,
                  minimumSize: Size(0, 34.h(context)),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'عرض الكل',
                  style: TextStyles.cairoRegular12Primary(context),
                ),
              ),
          ],
        ),
        verticalSpace(context, height: 16),
        if (announcements.isEmpty)
          const EmptyStateWidget(
            message: 'لا توجد أخبار أو تنبيهات حالياً',
            icon: SolarIconsOutline.bellOff,
          )
        else
          SizedBox(
            height: 142.h(context),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(vertical: 2.h(context)),
              itemCount: announcements.length,
              separatorBuilder: (context, index) =>
                  horizontalSpace(context, width: 12),
              itemBuilder: (context, index) {
                final item = announcements[index];
                return Container(
                  width: 310.w(context),
                  padding: context.responsivePadding(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: BorderRadius.circular(20.r(context)),
                    border: Border.all(color: AppColors.borderThemed(context)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(15.r(context)),
                        child: item.imageUrl != null
                            ? Image.network(
                                item.imageUrl!,
                                width: 92.w(context),
                                height: 116.h(context),
                                fit: BoxFit.cover,
                                errorBuilder: (_, _, _) => _newsImage(context),
                              )
                            : _newsImage(context),
                      ),
                      horizontalSpace(context, width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              item.title,
                              style: TextStyles.cairoBold14Black2(context)
                                  .copyWith(
                                    color: theme.colorScheme.onSurface,
                                    fontSize: 13.sp(context),
                                  ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            verticalSpace(context, height: 5),
                            Text(
                              item.description,
                              style:
                                  TextStyles.cairoRegular12DescriptionGray(
                                    context,
                                  ).copyWith(
                                    color: theme.colorScheme.onSurface
                                        .withValues(alpha: 0.68),
                                    fontSize: 11.sp(context),
                                    height: 1.5,
                                  ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
      ],
    );
  }

  Widget _newsImage(BuildContext context) {
    return Image.asset(
      Assets.imageNews,
      width: 92.w(context),
      height: 116.h(context),
      fit: BoxFit.cover,
    );
  }
}
