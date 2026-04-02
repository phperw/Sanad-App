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
    final Widget rowContent = Row(
      children: [
        Text(
          entry.medal,
          style: TextStyle(fontSize: 20.sp(context), fontFamily: 'Cairo'),
        ),
        horizontalSpace(context, width: 12),
        CircleAvatar(
          radius: 20.r(context),
          backgroundImage: NetworkImage(entry.imageUrl),
          // ignore: unnecessary_underscores
          onBackgroundImageError: (_, __) {},
        ),
        horizontalSpace(context, width: 12),
        Text(
          entry.name,
          style: TextStyles.cairoMedium14Black(context).copyWith(
            color: entry.isCurrentUser
                ? AppColors.chatChipBorder
                : AppColors.darkBlue,
            fontWeight: entry.isCurrentUser ? FontWeight.w700 : FontWeight.w600,
          ),
        ),
        const Spacer(),
        Text(
          entry.points,
          style: TextStyles.cairoMedium14Black(context).copyWith(
            color: entry.pointsColor,
            fontWeight: entry.isCurrentUser ? FontWeight.w700 : FontWeight.w600,
          ),
        ),
      ],
    );

    if (entry.isCurrentUser) {
      return Container(
        margin: context.responsivePadding(top: 8),
        padding: context.responsivePadding(horizontal: 12, vertical: 12),
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
      padding: context.responsivePadding(bottom: 12),
      child: rowContent,
    );
  }
}
