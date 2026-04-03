import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/helper/responsive_extensions.dart';
import '../../../../core/helper/spacing.dart';
import 'leaderboard_entry.dart';
import 'leaderboard_header.dart';
import 'leaderboard_item.dart';

class LeaderboardCardWidget extends StatelessWidget {
  final String currentUserName;
  final String currentUserPoints;
  final String? currentUserImageUrl;

  const LeaderboardCardWidget({
    super.key,
    required this.currentUserName,
    required this.currentUserPoints,
    this.currentUserImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final String safeUserName = currentUserName.length > 12
        ? '${currentUserName.substring(0, 12)}...'
        : currentUserName;

    final List<LeaderboardEntry> entries = [
      const LeaderboardEntry(
        medal: '🥇',
        name: 'محمد السيد',
        points: '850 نقطة',
        imageUrl: 'https://placehold.co/40x40',
        pointsColor: AppColors.orange,
      ),
      const LeaderboardEntry(
        medal: '🥈',
        name: 'سارة أحمد',
        points: '720 نقطة',
        imageUrl: 'https://placehold.co/40x40',
        pointsColor: AppColors.textGray,
      ),
      LeaderboardEntry(
        medal: '🥉',
        name: '$safeUserName (أنت)',
        points: '$currentUserPoints نقطة',
        imageUrl: currentUserImageUrl ?? 'https://placehold.co/40x40',
        isCurrentUser: true,
        pointsColor: AppColors.chatChipBorder,
      ),
    ];

    return Container(
      width: double.infinity,
      padding: context.responsivePadding(all: 20),
      decoration: _buildCardDecoration(context),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const LeaderboardHeader(),
          verticalSpace(context, height: 16),
          ...entries.map((entry) => LeaderboardItem(entry: entry)),
        ],
      ),
    );
  }

  ShapeDecoration _buildCardDecoration(BuildContext context) {
    return ShapeDecoration(
      color: AppColors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.r(context)),
      ),
      shadows: const [
        BoxShadow(
          color: AppColors.shadowColor,
          blurRadius: 4,
          offset: Offset(0, 4),
        ),
      ],
    );
  }
}
