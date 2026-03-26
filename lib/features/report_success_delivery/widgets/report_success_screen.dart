import 'package:flutter/material.dart';
import 'package:sanad/core/theme/app_colors.dart';
import 'package:sanad/features/success_checkin/widgets/success_background_widget.dart';
import '../../../core/helper/spacing.dart';
import 'widgets/new_badge_card_widget.dart';
import 'widgets/report_stats_card_widget.dart';
import 'widgets/report_success_header_widget.dart';
import 'widgets/return_home_action_widget.dart';

class ReportSuccessScreen extends StatelessWidget {
  const ReportSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          // 1. The decorative green circles
          SuccessBackgroundWidget(),

          // 2. The main content
          SafeArea(
            child: Column(
              children: [
                Spacer(flex: 2),

                // Paper Plane Icon and Titles
                ReportSuccessHeaderWidget(),

                Spacer(flex: 1),

                // Points and Hours Summary
                ReportStatsCardWidget(),

                verticalSpace(context, height: 16),

                // The Orange Badge Card
                NewBadgeCardWidget(),

                Spacer(flex: 3),

                // Bottom Text and Return Button
                ReturnHomeActionWidget(),

                verticalSpace(context, height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
