import 'package:flutter/material.dart';
import 'package:sanad/features/campaign/widgets/campaign_description_widget.dart';
import 'package:sanad/features/campaign/widgets/campaign_header_image_widget.dart';
import 'package:sanad/features/campaign/widgets/campaign_info_widget.dart';
import 'package:sanad/features/campaign/widgets/in_range_status_widget.dart';
import 'package:sanad/features/campaign/widgets/register_attendance_button_widget.dart';

class CampaignDetailsScreen extends StatelessWidget {
  const CampaignDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).cardColor,
      body: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CampaignHeaderImageWidget(),
            CampaignInfoWidget(),
            CampaignDescriptionWidget(),
            InRangeStatusWidget(),
            SizedBox(height: 20),
          ],
        ),
      ),
      bottomNavigationBar: const RegisterAttendanceButtonWidget(),
    );
  }
}
