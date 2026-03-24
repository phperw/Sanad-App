import 'package:flutter/material.dart';
import 'package:sanad/core/helper/responsive_extensions.dart';
import 'package:sanad/core/helper/spacing.dart';
import 'package:sanad/core/theme/app_colors.dart';
import 'package:sanad/core/theme/text_styles.dart';
import 'widgets/attendance_details_card_widget.dart';
import 'widgets/confirmation_actions_widget.dart';
import 'widgets/current_location_card_widget.dart';

class AttendanceConfirmationScreen extends StatelessWidget {
  const AttendanceConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'تأكيد الحضور',
          style: TextStyles.cairoBold32Dark(context).copyWith(
            fontSize: 18.sp(context),
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: AppColors.dark,
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
            Text(
              'موقعك الحالي',
              style: TextStyles.cairoRegular14Muted(context),
            ),
            verticalSpace(context, height: 12),
            const CurrentLocationCardWidget(),
            verticalSpace(context, height: 24),
            Text(
              'تفاصيل تسجيل الحضور',
              style: TextStyles.cairoRegular14Muted(context),
            ),
            verticalSpace(context, height: 12),
            const AttendanceDetailsCardWidget(),
            verticalSpace(context, height: 20),
          ],
        ),
      ),
      bottomNavigationBar: const ConfirmationActionsWidget(),
    );
  }
}