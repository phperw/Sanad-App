import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/helper/responsive_extensions.dart';
import '../../../../core/helper/spacing.dart';
import 'leaderboard_entry.dart';

class LeaderboardItem extends StatelessWidget {
  final LeaderboardEntry entry;

  const LeaderboardItem({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;

    final Widget rowContent = Row(
      children: [
        SizedBox(
          width: 28.w(context),
          child: Text(
            entry.medal,
            style: TextStyle(fontSize: 18.sp(context), fontFamily: 'Cairo'),
          ),
        ),
        horizontalSpace(context, width: 10),
        CircleAvatar(
          radius: 18.r(context),
          backgroundColor: AppColors.lightGray,
          backgroundImage: entry.imageUrl != null && entry.imageUrl!.isNotEmpty
              ? NetworkImage(entry.imageUrl!)
              : null,
          // ignore: unnecessary_underscores
          onBackgroundImageError: entry.imageUrl != null ? (_, __) {} : null,
          child: entry.imageUrl == null || entry.imageUrl!.isEmpty
              ? Text(
                  entry.name.isNotEmpty ? entry.name[0].toUpperCase() : '؟',
                  style: TextStyle(
                    fontSize: 14.sp(context),
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                )
              : null,
        ),
        horizontalSpace(context, width: 10),
        Expanded(
          child: Text(
            entry.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyles.cairoMedium14Black(context).copyWith(
              color: entry.isCurrentUser ? AppColors.primaryColor : onSurface,
              fontWeight:
                  entry.isCurrentUser ? FontWeight.w700 : FontWeight.w600,
            ),
          ),
        ),
        horizontalSpace(context, width: 8),
        Text(
          entry.points,
          style: TextStyles.cairoMedium14Black(context).copyWith(
            color: entry.pointsColor,
            fontWeight:
                entry.isCurrentUser ? FontWeight.w700 : FontWeight.w600,
          ),
        ),
      ],
    );

    if (entry.isCurrentUser) {
      return Container(
        margin: EdgeInsets.only(top: 8.h(context)),
        padding: EdgeInsets.symmetric(
          horizontal: 12.w(context),
          vertical: 12.h(context),
        ),
        decoration: ShapeDecoration(
          color: AppColors.lightGreenishWhite,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r(context)),
          ),
        ),
        child: rowContent,
      );
    }

    return Padding(
      padding: EdgeInsets.only(bottom: 12.h(context)),
      child: rowContent,
    );
  }
}