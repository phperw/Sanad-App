import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/helper/responsive_extensions.dart';
import '../../../../core/helper/spacing.dart';
import '../../data/models/get_user_card/profile_response.dart';
import 'leaderboard_entry.dart';
import 'leaderboard_header.dart';
import 'leaderboard_item.dart';

class LeaderboardCardWidget extends StatelessWidget {
  final ProfileLeaderboard leaderboard;

  const LeaderboardCardWidget({super.key, required this.leaderboard});

  String _medal(int rank) {
    switch (rank) {
      case 1:
        return '🥇';
      case 2:
        return '🥈';
      case 3:
        return '🥉';
      default:
        return '#$rank';
    }
  }

  Color _pointsColor(bool isCurrentUser, int rank) {
    if (isCurrentUser) return AppColors.primaryColor;
    switch (rank) {
      case 1:
        return AppColors.orange;
      case 2:
        return AppColors.textGray;
      default:
        return AppColors.primaryColor;
    }
  }

  @override
  Widget build(BuildContext context) {
    final cardColor = Theme.of(context).cardColor;

    final others = leaderboard.entries.where((e) => !e.isCurrentUser).toList()
      ..sort((a, b) => b.points.compareTo(a.points));

    final currentUser = leaderboard.currentUser;

    final List<LeaderboardEntry> displayEntries = [
      ...others.map(
        (u) => LeaderboardEntry(
          medal: _medal(u.rank),
          name: u.fullName,
          points: '${u.points} نقطة',
          imageUrl: u.avatarUrl,
          isCurrentUser: false,
          pointsColor: _pointsColor(false, u.rank),
        ),
      ),
      LeaderboardEntry(
        medal: _medal(currentUser.rank),
        name: '${currentUser.fullName} (أنت)',
        points: '${currentUser.points} نقطة',
        imageUrl: currentUser.avatarUrl,
        isCurrentUser: true,
        pointsColor: AppColors.primaryColor,
      ),
    ];

    return Container(
      width: double.infinity,
      padding: context.responsivePadding(all: 20),
      decoration: ShapeDecoration(
        color: cardColor,
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
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const LeaderboardHeader(),
          verticalSpace(context, height: 16),
          ...displayEntries.map((entry) => LeaderboardItem(entry: entry)),
        ],
      ),
    );
  }
}
