import 'package:flutter/material.dart';
import 'package:sanad/core/theme/app_colors.dart';

import 'widgets/success_background_widget.dart';
import 'widgets/success_header_widget.dart';
import 'widgets/success_summary_card_widget.dart';
import 'widgets/write_report_action_widget.dart';

class SuccessCheckinScreen extends StatelessWidget {
  const SuccessCheckinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.white,
      body: Stack(
        children: [
          // 1. The decorative green circles in the corner
          SuccessBackgroundWidget(),

          // 2. The main content centered on the screen
          SafeArea(
            child: Column(
              children: [
                Spacer(flex: 2),

                // Big Checkmark and Titles
                SuccessHeaderWidget(),

                Spacer(flex: 1),

                // The points and details card
                SuccessSummaryCardWidget(),

                Spacer(flex: 3),

                // The bottom text and action button
                WriteReportActionWidget(),

                SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
