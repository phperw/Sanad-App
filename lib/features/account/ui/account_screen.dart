import 'package:flutter/material.dart';
import '../../../core/helper/shared_pref_helper.dart';
import '../../../core/helper/spacing.dart';
import '../../../core/helper/responsive_extensions.dart';
import '../../../core/routing/router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import 'Widgets/circular_avatar_widget.dart';
import 'Widgets/active_volunteer_badge_widget.dart';
import 'Widgets/member_since_widget.dart';
import 'Widgets/stats_card_widget.dart';
import 'Widgets/leaderboard_card_widget.dart';
import 'Widgets/achievements_card_widget.dart';
import 'Widgets/certificates_card_widget.dart';
import 'package:go_router/go_router.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: context.responsivePadding(horizontal: 16, bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              verticalSpace(context, height: 32),
              const CircularAvatarWidget(
                imageUrl:
                    'https://static.wikia.nocookie.net/liverpoolfc/images/1/19/MSalah2025.jpeg/revision/latest?cb=20250807012340',
              ),
              verticalSpace(context, height: 12),
              const ActiveVolunteerBadgeWidget(),
              verticalSpace(context, height: 8),
              const MemberSinceWidget(),
              verticalSpace(context, height: 24),
              const StatsCardWidget(),
              verticalSpace(context, height: 16),
              const LeaderboardCardWidget(),
              verticalSpace(context, height: 16),
              const AchievementsCardWidget(),
              verticalSpace(context, height: 16),
              const CertificatesCardWidget(),
              verticalSpace(context, height: 16),

              ElevatedButton(
                onPressed: () async {
                  await SharedPrefHelper.clearAll();
                  // ignore: use_build_context_synchronously
                  context.go(AppRouter.kstart);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.sosRed,
                ),
                child: Text(
                  'تسجيل الخروج',
                  style: TextStyles.cairoBold14White(context),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
