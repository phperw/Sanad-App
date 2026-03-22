import 'package:flutter/material.dart';
import 'package:sanad/core/theme/app_colors.dart';
import 'package:sanad/features/campaign/widgets/campaign_description_widget.dart';
import 'package:sanad/features/campaign/widgets/campaign_header_image_widget.dart';
import 'package:sanad/features/campaign/widgets/campaign_info_widget.dart';
import 'package:sanad/features/campaign/widgets/in_range_status_widget.dart';
import 'package:sanad/features/campaign/widgets/register_attendance_button_widget.dart';

class CampaignDetailsScreen extends StatelessWidget {
  const CampaignDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: AppColors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. The top map image with back button and tag
            CampaignHeaderImageWidget(),

            // 2. Titles, Location, Time, and Volunteers
            CampaignInfoWidget(),

            // 3. The description paragraph
            CampaignDescriptionWidget(),

            // 4. The green "In Range" success card
            InRangeStatusWidget(),

            // Add some bottom padding so scrolling clears the sticky button
            SizedBox(height: 20),
          ],
        ),
      ),
      // 5. The sticky bottom button
      bottomNavigationBar: RegisterAttendanceButtonWidget(),
    );
  }
}
