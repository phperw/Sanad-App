import 'package:flutter/material.dart';
import 'package:sanad/core/helper/responsive_extensions.dart';
import 'package:sanad/core/helper/spacing.dart';
import 'package:sanad/core/theme/app_colors.dart';
import 'package:sanad/core/theme/text_styles.dart';

class MonthlyLeaderboardView extends StatefulWidget {
  const MonthlyLeaderboardView({super.key});

  @override
  State<MonthlyLeaderboardView> createState() => _MonthlyLeaderboardViewState();
}

class _MonthlyLeaderboardViewState extends State<MonthlyLeaderboardView> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchMonthlyData();
  }

  Future<void> _fetchMonthlyData() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Directionality(
      textDirection: TextDirection.rtl,
      child: SingleChildScrollView(
        padding: context.responsivePadding(horizontal: 16, bottom: 24),
        child: Column(
          children: [
            verticalSpace(context, height: 20),
            _PodiumSection(),
            verticalSpace(context, height: 20),
            _RanksCard(),
            verticalSpace(context, height: 12),
            _CurrentUserCard(),
          ],
        ),
      ),
    );
  }
}

class _PodiumSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: _PodiumItem(
            rank: 3,
            podiumHeight: 44,
            avatarSize: 56,
            innerAvatarSize: 52,
            name: 'خالد عمر',
            points: '1,950',
            borderColor: const Color(0xFFCD7F32),
            pointsColor: const Color(0xFFCD7F32),
            imageUrl: 'https://i.pravatar.cc/52?img=3',
          ),
        ),
        SizedBox(width: 12.w(context)),
        Expanded(
          child: _PodiumItem(
            rank: 1,
            podiumHeight: 80,
            avatarSize: 72,
            innerAvatarSize: 68,
            name: 'محمد السيد',
            points: '3,200',
            borderColor: const Color(0xFFF39C12),
            pointsColor: const Color(0xFFF39C12),
            imageUrl: 'https://i.pravatar.cc/68?img=1',
            showCrown: true,
          ),
        ),
        SizedBox(width: 12.w(context)),
        Expanded(
          child: _PodiumItem(
            rank: 2,
            podiumHeight: 60,
            avatarSize: 60,
            innerAvatarSize: 56,
            name: 'سارة أحمد',
            points: '2,580',
            borderColor: const Color(0xFF888888),
            pointsColor: AppColors.textGray,
            imageUrl: 'https://i.pravatar.cc/56?img=5',
          ),
        ),
      ],
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
  final String imageUrl;
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
    required this.imageUrl,
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
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              width: innerAvatarSize.w(context),
              height: innerAvatarSize.w(context),
            ),
          ),
        ),
        verticalSpace(context, height: 8),
        Text(
          name,
          textAlign: TextAlign.center,
          style: TextStyles.cairoBold16DarkBlue(context).copyWith(
            fontSize: rank == 1 ? 14.sp(context) : 13.sp(context),
            color: onSurface,
          ),
        ),
        verticalSpace(context, height: 2),
        Text(
          '$points نقطة',
          textAlign: TextAlign.center,
          style: TextStyles.cairoBold16DarkBlue(context).copyWith(
            fontSize: rank == 1 ? 14.sp(context) : 13.sp(context),
            color: pointsColor,
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
            style: TextStyles.cairoBold16White(
              context,
            ).copyWith(fontSize: rank == 1 ? 32.sp(context) : 28.sp(context)),
          ),
        ),
      ],
    );
  }
}

class _RanksCard extends StatelessWidget {
  final List<_RankEntry> entries = const [
    _RankEntry(
      rank: 4,
      name: 'فاطمة علي',
      points: 1750,
      initials: 'فع',
      gradientColors: [Color(0xFFFF8904), Color(0xFFF54900)],
    ),
    _RankEntry(
      rank: 5,
      name: 'عمر حسن',
      points: 1600,
      initials: 'عح',
      gradientColors: [Color(0xFF00D5BE), Color(0xFF009689)],
    ),
    _RankEntry(
      rank: 6,
      name: 'منى إبراهيم',
      points: 1480,
      initials: 'مإ',
      gradientColors: [Color(0xFF7C86FF), Color(0xFF4F39F6)],
    ),
    _RankEntry(
      rank: 7,
      name: 'كريم أحمد',
      points: 1350,
      initials: 'كأ',
      gradientColors: [Color(0xFFFF6467), Color(0xFFE7000B)],
    ),
  ];

  @override
  Widget build(BuildContext context) {
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
          final e = entries[i];
          final isLast = i == entries.length - 1;
          return Column(
            children: [
              _RankRow(entry: e),
              if (!isLast)
                Divider(height: 1, thickness: 1, color: AppColors.cardBorder),
            ],
          );
        }),
      ),
    );
  }
}

class _RankEntry {
  final int rank;
  final String name;
  final int points;
  final String initials;
  final List<Color> gradientColors;

  const _RankEntry({
    required this.rank,
    required this.name,
    required this.points,
    required this.initials,
    required this.gradientColors,
  });
}

class _RankRow extends StatelessWidget {
  final _RankEntry entry;

  const _RankRow({required this.entry});

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Padding(
      padding: context.responsivePadding(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          SizedBox(
            width: 24.w(context),
            child: Text(
              '${entry.rank}',
              textAlign: TextAlign.center,
              style: TextStyles.cairoBold16DarkBlue(
                context,
              ).copyWith(fontSize: 18.sp(context), color: AppColors.textGray),
            ),
          ),
          SizedBox(width: 12.w(context)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.name,
                  style: TextStyles.cairoBold16DarkBlue(
                    context,
                  ).copyWith(fontSize: 14.sp(context), color: onSurface),
                ),
                Text(
                  '${entry.points} نقطة',
                  style: TextStyles.cairoRegular12Gray(context).copyWith(
                    color: AppColors.textGray,
                    fontSize: 12.sp(context),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w(context)),
          Container(
            width: 44.w(context),
            height: 44.w(context),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: entry.gradientColors,
              ),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              entry.initials,
              style: TextStyles.cairoBold16White(
                context,
              ).copyWith(fontSize: 16.sp(context)),
            ),
          ),
          SizedBox(width: 12.w(context)),
          SizedBox(
            width: 36.w(context),
            child: Text(
              '${entry.points}',
              textAlign: TextAlign.end,
              style: TextStyles.cairoBold16DarkBlue(
                context,
              ).copyWith(color: AppColors.chatChipBorder),
            ),
          ),
        ],
      ),
    );
  }
}

class _CurrentUserCard extends StatelessWidget {
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
            width: 24.w(context),
            child: Text(
              '12',
              textAlign: TextAlign.center,
              style: TextStyles.cairoBold16DarkBlue(context).copyWith(
                fontSize: 18.sp(context),
                color: AppColors.chatChipBorder,
              ),
            ),
          ),
          SizedBox(width: 12.w(context)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'محمد حسام (أنت)',
                  style: TextStyles.cairoBold16DarkBlue(context).copyWith(
                    fontSize: 14.sp(context),
                    color: AppColors.chatChipBorder,
                  ),
                ),
                Text(
                  '↑ 5 مراكز هذا الشهر',
                  style: TextStyles.cairoRegular12Gray(context).copyWith(
                    color: const Color(0xFF2ECC71),
                    fontSize: 11.sp(context),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w(context)),
          Container(
            width: 44.w(context),
            height: 44.w(context),
            padding: const EdgeInsets.all(1.1),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.chatChipBorder, width: 1.1),
            ),
            child: ClipOval(
              child: Image.network(
                'https://i.pravatar.cc/42?img=8',
                fit: BoxFit.cover,
              ),
            ),
          ),
          SizedBox(width: 12.w(context)),
          SizedBox(
            width: 36.w(context),
            child: Text(
              '980',
              textAlign: TextAlign.end,
              style: TextStyles.cairoBold16DarkBlue(
                context,
              ).copyWith(color: AppColors.chatChipBorder),
            ),
          ),
        ],
      ),
    );
  }
}
