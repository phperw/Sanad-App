import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:sanad/core/di/dependency_injection.dart';
import 'package:sanad/core/helper/responsive_extensions.dart';
import 'package:sanad/core/helper/spacing.dart';
import 'package:sanad/core/theme/app_colors.dart';
import 'package:sanad/core/theme/text_styles.dart';
import 'package:sanad/core/widgets/error_screen.dart';
import '../../data/models/leaderboard_response.dart';
import '../../logic/leaderboard_state.dart';
import '../../logic/monthly_cubit/monthly_leaderboard_cubit.dart';

class MonthlyLeaderboardView extends StatelessWidget {
  const MonthlyLeaderboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          getIt<MonthlyLeaderboardCubit>()..getMonthlyLeaderboard(),
      child: const _MonthlyLeaderboardContent(),
    );
  }
}

class _MonthlyLeaderboardContent extends StatelessWidget {
  const _MonthlyLeaderboardContent();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MonthlyLeaderboardCubit, LeaderboardState>(
      builder: (context, state) {
        if (state is LeaderboardFailure) {
          return Center(
            child: ErrorScreen(
              message: state.error.message,
              onRetry: () => context
                  .read<MonthlyLeaderboardCubit>()
                  .getMonthlyLeaderboard(),
            ),
          );
        }

        final isLoading =
            state is LeaderboardInitial || state is LeaderboardLoading;
        final data =
            state is LeaderboardSuccess ? state.data.leaderboard : _fakeData;

        return Skeletonizer(
          enabled: isLoading,
          enableSwitchAnimation: true,
          effect: ShimmerEffect(
            baseColor: AppColors.lightGray,
            highlightColor: AppColors.lightGreenishWhite,
            duration: const Duration(milliseconds: 1200),
          ),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: SingleChildScrollView(
              padding: context.responsivePadding(horizontal: 16, bottom: 24),
              child: Column(
                children: [
                  verticalSpace(context, height: 20),
                  _PodiumSection(data: data),
                  verticalSpace(context, height: 20),
                  _RanksCard(data: data),
                  verticalSpace(context, height: 12),
                  _CurrentUserCard(
                    currentUser: data.currentUser,
                    subtitle: '${data.currentUser.points} نقطة هذا الشهر',
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

final _fakeUser = LeaderboardUser(
  rank: 1,
  id: 0,
  fullName: 'اسم المستخدم',
  avatarUrl: null,
  isCurrentUser: false,
  status: 'ACTIVE',
  points: 999,
  totalHours: 0,
  completedCampaigns: 0,
  reportsCount: 0,
);

final _fakeData = LeaderboardData(
  period: 'monthly',
  totalParticipants: 10,
  currentUserRank: 12,
  topThree: [_fakeUser, _fakeUser, _fakeUser],
  entries: [_fakeUser, _fakeUser, _fakeUser, _fakeUser],
  currentUser: LeaderboardUser(
    rank: 12,
    id: 0,
    fullName: 'أنت',
    avatarUrl: null,
    isCurrentUser: true,
    status: 'ACTIVE',
    points: 980,
    totalHours: 0,
    completedCampaigns: 0,
    reportsCount: 0,
  ),
);

String _initials(String name) {
  final parts = name.trim().split(' ').where((p) => p.isNotEmpty).toList();
  if (parts.isEmpty) return '؟';
  if (parts.length == 1) return parts[0][0].toUpperCase();
  return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
}

const _gradients = [
  [Color(0xFFFF8904), Color(0xFFF54900)],
  [Color(0xFF00D5BE), Color(0xFF009689)],
  [Color(0xFF7C86FF), Color(0xFF4F39F6)],
  [Color(0xFFFF6467), Color(0xFFE7000B)],
  [Color(0xFFF39C12), Color(0xFFE67E22)],
  [Color(0xFF2ECC71), Color(0xFF27AE60)],
];

class _PodiumSection extends StatelessWidget {
  final LeaderboardData data;
  const _PodiumSection({required this.data});

  static const _podiumConfig = [
    {'rank': 3, 'podiumHeight': 44.0, 'avatarSize': 56.0, 'innerSize': 52.0},
    {'rank': 1, 'podiumHeight': 80.0, 'avatarSize': 72.0, 'innerSize': 68.0},
    {'rank': 2, 'podiumHeight': 60.0, 'avatarSize': 60.0, 'innerSize': 56.0},
  ];

  static const _rankColors = {
    1: Color(0xFFF39C12),
    2: Color(0xFF888888),
    3: Color(0xFFCD7F32),
  };

  @override
  Widget build(BuildContext context) {
    final top3 = data.topThree;

    LeaderboardUser? userForRank(int rank) {
      try {
        return top3.firstWhere((u) => u.rank == rank);
      } catch (_) {
        return top3.length >= rank ? top3[rank - 1] : null;
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: _podiumConfig.map((cfg) {
        final rank = cfg['rank'] as int;
        final user = userForRank(rank);
        if (user == null) return const Expanded(child: SizedBox());
        final color = _rankColors[rank]!;
        return Expanded(
          child: _PodiumItem(
            rank: rank,
            podiumHeight: cfg['podiumHeight'] as double,
            avatarSize: cfg['avatarSize'] as double,
            innerAvatarSize: cfg['innerSize'] as double,
            name: user.fullName,
            points: '${user.points}',
            borderColor: color,
            pointsColor: rank == 2 ? AppColors.textGray : color,
            avatarUrl: user.avatarUrl,
            showCrown: rank == 1,
          ),
        );
      }).toList(),
    );
  }
}

class _PodiumItem extends StatelessWidget {
  final int rank;
  final double podiumHeight;
  final double avatarSize;
  final double innerAvatarSize;
  final String name;
  final String points;
  final Color borderColor;
  final Color pointsColor;
  final String? avatarUrl;
  final bool showCrown;

  const _PodiumItem({
    required this.rank,
    required this.podiumHeight,
    required this.avatarSize,
    required this.innerAvatarSize,
    required this.name,
    required this.points,
    required this.borderColor,
    required this.pointsColor,
    required this.avatarUrl,
    this.showCrown = false,
  });

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (showCrown)
          Text('👑', style: TextStyle(fontSize: 24.sp(context)))
        else
          SizedBox(height: 36.h(context)),
        Container(
          width: avatarSize.w(context),
          height: avatarSize.w(context),
          decoration: ShapeDecoration(
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 2.2, color: borderColor),
              borderRadius: BorderRadius.circular(100),
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: avatarUrl != null && avatarUrl!.isNotEmpty
                ? Image.network(
                    avatarUrl!,
                    fit: BoxFit.cover,
                    width: innerAvatarSize.w(context),
                    height: innerAvatarSize.w(context),
                  )
                : Container(
                    color: borderColor.withOpacity(0.15),
                    alignment: Alignment.center,
                    child: Text(
                      _initials(name),
                      style: TextStyles.cairoBold16DarkBlue(context)
                          .copyWith(color: borderColor, fontSize: 14.sp(context)),
                    ),
                  ),
          ),
        ),
        verticalSpace(context, height: 8),
        Text(
          name,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyles.cairoBold16DarkBlue(context).copyWith(
            fontSize: rank == 1 ? 14.sp(context) : 13.sp(context),
            color: onSurface,
          ),
        ),
        verticalSpace(context, height: 2),
        FittedBox(
          fit: BoxFit.scaleDown,
          child: Text(
            '$points نقطة',
            textAlign: TextAlign.center,
            style: TextStyles.cairoBold16DarkBlue(context).copyWith(
              fontSize: rank == 1 ? 14.sp(context) : 13.sp(context),
              color: pointsColor,
            ),
          ),
        ),
        verticalSpace(context, height: 8),
        Container(
          width: double.infinity,
          height: podiumHeight.h(context),
          decoration: ShapeDecoration(
            color: borderColor,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            '$rank',
            style: TextStyles.cairoBold16White(context)
                .copyWith(fontSize: rank == 1 ? 32.sp(context) : 28.sp(context)),
          ),
        ),
      ],
    );
  }
}

class _RanksCard extends StatelessWidget {
  final LeaderboardData data;
  const _RanksCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final entries = data.entries;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.cardBackground(context),
        borderRadius: BorderRadius.circular(20.r(context)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 2,
            offset: Offset(0, 1),
            spreadRadius: -1,
          ),
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: List.generate(entries.length, (i) {
          final user = entries[i];
          final isLast = i == entries.length - 1;
          final gradient = _gradients[i % _gradients.length];
          return Column(
            children: [
              _RankRow(user: user, gradientColors: gradient),
              if (!isLast)
                Divider(height: 1, thickness: 1, color: AppColors.cardBorder),
            ],
          );
        }),
      ),
    );
  }
}

class _RankRow extends StatelessWidget {
  final LeaderboardUser user;
  final List<Color> gradientColors;

  const _RankRow({required this.user, required this.gradientColors});

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Padding(
      padding: context.responsivePadding(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          SizedBox(
            width: 28.w(context),
            child: Text(
              '${user.rank}',
              textAlign: TextAlign.center,
              style: TextStyles.cairoBold16DarkBlue(context).copyWith(
                fontSize: 18.sp(context),
                color: AppColors.textGray,
              ),
            ),
          ),
          SizedBox(width: 12.w(context)),
          user.avatarUrl != null && user.avatarUrl!.isNotEmpty
              ? Container(
                  width: 46.w(context),
                  height: 46.w(context),
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: ClipOval(
                    child: Image.network(user.avatarUrl!, fit: BoxFit.cover),
                  ),
                )
              : Container(
                  width: 46.w(context),
                  height: 46.w(context),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: gradientColors,
                    ),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    _initials(user.fullName),
                    style: TextStyles.cairoBold16White(context)
                        .copyWith(fontSize: 15.sp(context)),
                  ),
                ),
          SizedBox(width: 12.w(context)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  user.fullName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.cairoBold16DarkBlue(context)
                      .copyWith(fontSize: 14.sp(context), color: onSurface),
                ),
                Text(
                  '${user.points} نقطة',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.cairoRegular12Gray(context).copyWith(
                    color: AppColors.textGray,
                    fontSize: 12.sp(context),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w(context)),
          Text(
            '${user.points}',
            maxLines: 1,
            textAlign: TextAlign.end,
            style: TextStyles.cairoBold16DarkBlue(context).copyWith(
              color: AppColors.chatChipBorder,
              fontSize: 14.sp(context),
            ),
          ),
        ],
      ),
    );
  }
}

class _CurrentUserCard extends StatelessWidget {
  final LeaderboardUser currentUser;
  final String subtitle;

  const _CurrentUserCard({
    required this.currentUser,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.lightGreenishWhite,
        borderRadius: BorderRadius.circular(20.r(context)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 2,
            offset: Offset(0, 1),
            spreadRadius: -1,
          ),
          BoxShadow(
            color: Color(0x19000000),
            blurRadius: 3,
            offset: Offset(0, 1),
          ),
        ],
      ),
      padding: context.responsivePadding(horizontal: 16, vertical: 16),
      child: Row(
        children: [
          SizedBox(
            width: 28.w(context),
            child: Text(
              '${currentUser.rank}',
              textAlign: TextAlign.center,
              style: TextStyles.cairoBold16DarkBlue(context).copyWith(
                fontSize: 18.sp(context),
                color: AppColors.chatChipBorder,
              ),
            ),
          ),
          SizedBox(width: 12.w(context)),
          Container(
            width: 46.w(context),
            height: 46.w(context),
            padding: const EdgeInsets.all(1.1),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.chatChipBorder, width: 1.1),
            ),
            child: currentUser.avatarUrl != null &&
                    currentUser.avatarUrl!.isNotEmpty
                ? ClipOval(
                    child: Image.network(
                      currentUser.avatarUrl!,
                      fit: BoxFit.cover,
                    ),
                  )
                : ClipOval(
                    child: Container(
                      color: AppColors.chatChipBorder.withOpacity(0.1),
                      alignment: Alignment.center,
                      child: Text(
                        _initials(currentUser.fullName),
                        style: TextStyles.cairoBold16DarkBlue(context).copyWith(
                          color: AppColors.chatChipBorder,
                          fontSize: 15.sp(context),
                        ),
                      ),
                    ),
                  ),
          ),
          SizedBox(width: 12.w(context)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${currentUser.fullName} (أنت)',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.cairoBold16DarkBlue(context).copyWith(
                    fontSize: 14.sp(context),
                    color: AppColors.chatChipBorder,
                  ),
                ),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.cairoRegular12Gray(context).copyWith(
                    color: const Color(0xFF2ECC71),
                    fontSize: 11.sp(context),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 8.w(context)),
          Text(
            '${currentUser.points}',
            maxLines: 1,
            textAlign: TextAlign.end,
            style: TextStyles.cairoBold16DarkBlue(context).copyWith(
              color: AppColors.chatChipBorder,
              fontSize: 14.sp(context),
            ),
          ),
        ],
      ),
    );
  }
}