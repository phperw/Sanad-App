import 'package:flutter/material.dart';
import 'widgets/success_background_widget.dart';
import 'widgets/success_header_widget.dart';
import 'widgets/success_summary_card_widget.dart';
import 'widgets/write_report_action_widget.dart';

class SuccessCheckinScreen extends StatelessWidget {
  const SuccessCheckinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: const Stack(
        children: [
          SuccessBackgroundWidget(),
          SafeArea(
            child: Column(
              children: [
                Spacer(flex: 2),
                SuccessHeaderWidget(),
                Spacer(flex: 1),
                SuccessSummaryCardWidget(),
                Spacer(flex: 3),
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
