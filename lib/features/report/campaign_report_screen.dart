import 'package:flutter/material.dart';
import 'package:sanad/core/helper/responsive_extensions.dart';
import 'package:sanad/core/helper/spacing.dart';
import 'package:sanad/core/theme/text_styles.dart';
import 'widgets/campaign_notes_input_widget.dart';
import 'widgets/campaign_rating_widget.dart';
import 'widgets/photo_upload_widget.dart';
import 'widgets/report_actions_widget.dart';
import 'widgets/report_header_card_widget.dart';

class CampaignReportScreen extends StatelessWidget {
  const CampaignReportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'تقرير الحملة',
          style: TextStyles.cairoBold32Dark(context)
              .copyWith(fontSize: 18.sp(context), color: onSurface),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: onSurface,
            size: 20.r(context),
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: context.responsivePadding(horizontal: 20, top: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ReportHeaderCardWidget(),
            verticalSpace(context, height: 24),
            const CampaignRatingWidget(),
            verticalSpace(context, height: 24),
            const CampaignNotesInputWidget(),
            verticalSpace(context, height: 24),
            const PhotoUploadWidget(),
            verticalSpace(context, height: 32),
            const ReportActionsWidget(),
            verticalSpace(context, height: 32),
          ],
        ),
      ),
    );
  }
}