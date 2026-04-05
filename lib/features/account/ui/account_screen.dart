import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../core/di/dependency_injection.dart';
import '../../../core/helper/shared_pref_helper.dart';
import '../../../core/helper/spacing.dart';
import '../../../core/helper/responsive_extensions.dart';
import '../../../core/routing/router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../../core/widgets/error_screen.dart';
import '../data/models/get_user_card/profile_response.dart';
import '../logic/get_user_card/account_cubit.dart';
import '../logic/get_user_card/account_state.dart';
import 'Widgets/circular_avatar_widget.dart';
import 'Widgets/active_volunteer_badge_widget.dart';
import 'Widgets/member_since_widget.dart';
import 'Widgets/stats_card_widget.dart';
import 'Widgets/leaderboard_card_widget.dart';
import 'Widgets/achievements_card_widget.dart';
import 'Widgets/certificates_card_widget.dart';
import 'Widgets/theme_toggle.dart';

// ─── Fake data للـ skeleton ─────────────────────────────────────────────────

final _fakeVolunteer = ProfileVolunteer(
  id: 0,
  fullName: 'اسم المستخدم الكامل',
  nationalId: '00000000000000',
  email: 'example@email.com',
  phone: '01000000000',
  avatarUrl: null,
  status: 'ACTIVE',
  statusLabel: 'متطوع نشط 🌟',
  memberSinceLabel: 'عضو منذ يناير ٢٠٢٦',
  joinDate: DateTime.now().toIso8601String(),
);

final _fakeStats = ProfileStats(
  totalHours: 120,
  points: 470,
  campaignsCompleted: 8,
  badgesCount: 3,
  certificatesCount: 2,
);

final _fakeLeaderboardUser = LeaderboardUser(
  rank: 1,
  id: 0,
  fullName: 'مستخدم تجريبي',
  avatarUrl: null,
  isCurrentUser: false,
  status: 'ACTIVE',
  points: 800,
  totalHours: 100,
  completedCampaigns: 5,
  reportsCount: 8,
);

final _fakeCurrentUser = LeaderboardUser(
  rank: 3,
  id: 0,
  fullName: 'أنت',
  avatarUrl: null,
  isCurrentUser: true,
  status: 'ACTIVE',
  points: 470,
  totalHours: 60,
  completedCampaigns: 3,
  reportsCount: 4,
);

final _fakeLeaderboard = ProfileLeaderboard(
  period: 'weekly',
  totalParticipants: 20,
  currentUserRank: 3,
  topThree: [_fakeLeaderboardUser],
  entries: [_fakeLeaderboardUser],
  currentUser: _fakeCurrentUser,
);

final _fakeAchievements = ProfileAchievements(
  achievedCount: 3,
  totalCount: 6,
  items: [],
);

final _fakeCertificates = ProfileCertificates(count: 2, items: []);

// ─── Screen ──────────────────────────────────────────────────────────────────

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AccountCubitCard>()..getProfile(),
      child: const _AccountView(),
    );
  }
}

class _AccountView extends StatelessWidget {
  const _AccountView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountCubitCard, AccountStateCard>(
      builder: (context, state) {
        if (state is AccountFailureCard) {
          return Scaffold(
            body: SafeArea(
              child: Center(
                child: ErrorScreen(
                  message: state.error.message,
                  onRetry: () => context.read<AccountCubitCard>().getProfile(),
                ),
              ),
            ),
          );
        }

        final isLoading =
            state is AccountLoadingCard || state is AccountInitial;

        final volunteer = state is AccountSuccessCard
            ? state.data.profile.volunteer
            : _fakeVolunteer;
        final stats = state is AccountSuccessCard
            ? state.data.profile.stats
            : _fakeStats;
        final leaderboard = state is AccountSuccessCard
            ? state.data.profile.leaderboard
            : _fakeLeaderboard;
        final achievements = state is AccountSuccessCard
            ? state.data.profile.achievements
            : _fakeAchievements;
        final certificates = state is AccountSuccessCard
            ? state.data.profile.certificates
            : _fakeCertificates;

        return Scaffold(
          body: Skeletonizer(
            enabled: isLoading,
            enableSwitchAnimation: true,
            effect: ShimmerEffect(
              baseColor: AppColors.lightGray,
              highlightColor: AppColors.lightGreenishWhite,
              duration: const Duration(milliseconds: 1200),
            ),
            child: SafeArea(
              child: Stack(
                children: [
                  SingleChildScrollView(
                    padding: context.responsivePadding(
                      horizontal: 16,
                      bottom: 24,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        verticalSpace(context, height: 52),
                        _AvatarSection(volunteer: volunteer),
                        verticalSpace(context, height: 12),
                        Text(
                          volunteer.fullName,
                          style: TextStyles.cairoBold20Dark(context),
                        ),
                        verticalSpace(context, height: 8),
                        ActiveVolunteerBadgeWidget(
                          label:
                              volunteer.statusLabel ??
                              (volunteer.status == 'ACTIVE'
                                  ? 'متطوع نشط 🌟'
                                  : 'غير نشط'),
                        ),
                        verticalSpace(context, height: 8),
                        MemberSinceWidget(
                          date:
                              volunteer.memberSinceLabel ?? volunteer.joinDate,
                        ),
                        verticalSpace(context, height: 24),
                        StatsCardWidget(
                          points: '${stats.points}',
                          campaigns: '${stats.campaignsCompleted}',
                          hours: '${stats.totalHours}',
                        ),
                        verticalSpace(context, height: 16),
                        LeaderboardCardWidget(leaderboard: leaderboard),
                        verticalSpace(context, height: 16),
                        AchievementsCardWidget(
                          achieved: '${achievements.achievedCount}',
                          total: '${achievements.totalCount}',
                        ),
                        verticalSpace(context, height: 16),
                        CertificatesCardWidget(
                          certificates: certificates.items,
                        ),
                        verticalSpace(context, height: 16),
                        const _LogoutButton(),
                      ],
                    ),
                  ),
                  const Positioned(top: 12, left: 16, child: ThemeToggle()),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ─── Avatar Section ──────────────────────────────────────────────────────────

class _AvatarSection extends StatelessWidget {
  final ProfileVolunteer volunteer;

  const _AvatarSection({required this.volunteer});

  @override
  Widget build(BuildContext context) {
    if (volunteer.avatarUrl != null && volunteer.avatarUrl!.isNotEmpty) {
      return CircularAvatarWidget(imageUrl: volunteer.avatarUrl!);
    }

    return Container(
      width: 80.w(context),
      height: 80.w(context),
      decoration: ShapeDecoration(
        color: AppColors.lightGreenishWhite,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 2.2.w(context),
            color: AppColors.chatChipBorder,
          ),
          borderRadius: BorderRadius.circular(100.r(context)),
        ),
      ),
      child: Center(
        child: Text(
          volunteer.fullName.isNotEmpty
              ? volunteer.fullName[0].toUpperCase()
              : '؟',
          style: TextStyles.cairoBold24Primary(context),
        ),
      ),
    );
  }
}

// ─── Logout Button ───────────────────────────────────────────────────────────

class _LogoutButton extends StatelessWidget {
  const _LogoutButton();

  @override
  Widget build(BuildContext context) {
    return Skeleton.ignore(
      child: ElevatedButton.icon(
        onPressed: () async {
          await SharedPrefHelper.clearAll();
          if (context.mounted) context.go(AppRouter.kstart);
        },
        icon: const Icon(Icons.logout_rounded, color: Colors.white),
        label: Text(
          'تسجيل الخروج',
          style: TextStyles.cairoBold14White(context),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.sosRed,
          minimumSize: Size(double.infinity, 52.h(context)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r(context)),
          ),
        ),
      ),
    );
  }
}
