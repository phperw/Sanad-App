import 'package:flutter/material.dart';
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          SuccessBackgroundWidget(),
          SafeArea(
            child: Column(
              children: [
                Spacer(flex: 2),
                ReportSuccessHeaderWidget(),
                Spacer(flex: 1),
                ReportStatsCardWidget(),
                verticalSpace(context, height: 16),
                NewBadgeCardWidget(),
                Spacer(flex: 3),
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
