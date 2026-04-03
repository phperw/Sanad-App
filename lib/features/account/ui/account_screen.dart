// import 'package:flutter/material.dart';
// import '../../../core/helper/shared_pref_helper.dart';
// import '../../../core/helper/spacing.dart';
// import '../../../core/helper/responsive_extensions.dart';
// import '../../../core/routing/router.dart';
// import '../../../core/theme/app_colors.dart';
// import '../../../core/theme/text_styles.dart';
// import 'Widgets/circular_avatar_widget.dart';
// import 'Widgets/active_volunteer_badge_widget.dart';
// import 'Widgets/member_since_widget.dart';
// import 'Widgets/stats_card_widget.dart';
// import 'Widgets/leaderboard_card_widget.dart';
// import 'Widgets/achievements_card_widget.dart';
// import 'Widgets/certificates_card_widget.dart';
// import 'package:go_router/go_router.dart';

// class AccountScreen extends StatelessWidget {
//   const AccountScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: SingleChildScrollView(
//           padding: context.responsivePadding(horizontal: 16, bottom: 24),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               verticalSpace(context, height: 32),
//               const CircularAvatarWidget(
//                 imageUrl:
//                     'https://static.wikia.nocookie.net/liverpoolfc/images/1/19/MSalah2025.jpeg/revision/latest?cb=20250807012340',
//               ),
//               verticalSpace(context, height: 12),
//               const ActiveVolunteerBadgeWidget(),
//               verticalSpace(context, height: 8),
//               const MemberSinceWidget(),
//               verticalSpace(context, height: 24),
//               const StatsCardWidget(),
//               verticalSpace(context, height: 16),
//               const LeaderboardCardWidget(),
//               verticalSpace(context, height: 16),
//               const AchievementsCardWidget(),
//               verticalSpace(context, height: 16),
//               const CertificatesCardWidget(),
//               verticalSpace(context, height: 16),

//               ElevatedButton(
//                 onPressed: () async {
//                   await SharedPrefHelper.clearAll();
//                   // ignore: use_build_context_synchronously
//                   context.go(AppRouter.kstart);
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: AppColors.sosRed,
//                 ),
//                 child: Text(
//                   'تسجيل الخروج',
//                   style: TextStyles.cairoBold14White(context),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
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
import '../logic/account_cubit.dart';
import '../logic/account_state.dart';
import '../data/models/profile_response.dart';
import 'Widgets/circular_avatar_widget.dart';
import 'Widgets/active_volunteer_badge_widget.dart';
import 'Widgets/member_since_widget.dart';
import 'Widgets/stats_card_widget.dart';
import 'Widgets/leaderboard_card_widget.dart';
import 'Widgets/achievements_card_widget.dart';
import 'Widgets/certificates_card_widget.dart';

final _fakeUser = ProfileUser(
  id: 0,
  fullName: 'اسم المستخدم الكامل',
  nationalId: '00000000000000',
  email: 'example@email.com',
  phone: '01000000000',
  avatarUrl: null,
  gender: null,
  dateOfBirth: null,
  city: null,
  joinDate: DateTime.now().toIso8601String(),
  status: 'ACTIVE',
  totalHours: 120,
  points: 470,
  createdAt: DateTime.now().toIso8601String(),
  stats: const ProfileStats(campaignsCreated: 18, assignedTasks: 5, badges: 4),
);

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<AccountCubit>()..getProfile(),
      child: const _AccountView(),
    );
  }
}

class _AccountView extends StatelessWidget {
  const _AccountView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AccountCubit, AccountState>(
      builder: (context, state) {
        if (state is AccountFailure) {
          return Scaffold(
            body: SafeArea(
              child: Center(
                child: ErrorScreen(
                  message: state.error.message,
                  onRetry: () => context.read<AccountCubit>().getProfile(),
                ),
              ),
            ),
          );
        }

        final isLoading = state is AccountLoading || state is AccountInitial;
        final user = state is AccountSuccess ? state.data.user : _fakeUser;

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
              child: SingleChildScrollView(
                padding: context.responsivePadding(horizontal: 16, bottom: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    verticalSpace(context, height: 32),
                    _AvatarSection(user: user),
                    verticalSpace(context, height: 12),
                    Text(
                      user.fullName,
                      style: TextStyles.cairoBold20Dark(context),
                    ),
                    verticalSpace(context, height: 8),

                    ActiveVolunteerBadgeWidget(
                      label: user.status == 'ACTIVE'
                          ? 'متطوع نشط 🌟'
                          : 'غير نشط',
                    ),

                    verticalSpace(context, height: 8),
                    MemberSinceWidget(date: user.formattedJoinDate),
                    verticalSpace(context, height: 24),
                    StatsCardWidget(
                      points: '${user.points}',
                      campaigns: '${user.stats.campaignsCreated}',
                      hours: '${user.totalHours}',
                    ),
                    verticalSpace(context, height: 16),
                    LeaderboardCardWidget(
                      currentUserName: user.fullName,
                      currentUserPoints: '${user.points}',
                      currentUserImageUrl: user.avatarUrl,
                    ),
                    verticalSpace(context, height: 16),
                    AchievementsCardWidget(
                      achieved: '${user.stats.badges}',
                      total: '8',
                    ),
                    verticalSpace(context, height: 16),
                    const CertificatesCardWidget(),
                    verticalSpace(context, height: 16),
                    _LogoutButton(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AvatarSection extends StatelessWidget {
  final ProfileUser user;

  const _AvatarSection({required this.user});

  @override
  Widget build(BuildContext context) {
    if (user.avatarUrl != null && user.avatarUrl!.isNotEmpty) {
      return CircularAvatarWidget(imageUrl: user.avatarUrl!);
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
          user.fullName.isNotEmpty ? user.fullName[0].toUpperCase() : '؟',
          style: TextStyles.cairoBold24Primary(context),
        ),
      ),
    );
  }
}

class _LogoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Skeleton.ignore(
      child: ElevatedButton(
        onPressed: () async {
          await SharedPrefHelper.clearAll();
          if (context.mounted) context.go(AppRouter.kstart);
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.sosRed,
          minimumSize: Size(double.infinity, 52.h(context)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r(context)),
          ),
        ),
        child: Text(
          'تسجيل الخروج',
          style: TextStyles.cairoBold14White(context),
        ),
      ),
    );
  }
}
