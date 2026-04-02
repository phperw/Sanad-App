import 'package:flutter/material.dart';
import 'package:sanad/core/theme/app_colors.dart';
import 'package:sanad/core/theme/text_styles.dart';
import 'package:sanad/core/constants/app_images.dart';
import 'package:sanad/core/helper/responsive_extensions.dart';
import 'package:sanad/core/helper/spacing.dart';
import '../../data/models/home_response.dart';
import 'empty_state_widget.dart';

class NewsSection extends StatelessWidget {
  final List<Announcement> announcements;

  const NewsSection({super.key, required this.announcements});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "آخر الأخبار والتنبيهات",
              style: TextStyles.cairoBold18Black2(context),
            ),
            if (announcements.isNotEmpty)
              GestureDetector(
                onTap: () {},
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
            icon: Icons.notifications_off_outlined,
          )
        else
          SizedBox(
            height: 120.h(context),
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: announcements.length,
              separatorBuilder: (context, index) =>
                  horizontalSpace(context, width: 12),
              itemBuilder: (context, index) {
                final item = announcements[index];
                return Container(
                  width: 300.w(context),
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.w(context),
                    vertical: 16.h(context),
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.lightGreenishWhite,
                    borderRadius: BorderRadius.circular(12.r(context)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(10.r(context)),
                        child: item.imageUrl != null
                            ? Image.network(
                                item.imageUrl!,
                                width: 80.w(context),
                                height: 88.h(context),
                                fit: BoxFit.cover,
                              )
                            : Image.asset(
                                Assets.imageNews,
                                width: 80.w(context),
                                height: 88.h(context),
                                fit: BoxFit.cover,
                              ),
                      ),
                      horizontalSpace(context, width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              item.title,
                              style: TextStyles.cairoBold14Black2(context),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            verticalSpace(context, height: 4),
                            Text(
                              item.description,
                              style: TextStyles.cairoRegular12DescriptionGray(
                                context,
                              ),
                              maxLines: 2,
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
}
