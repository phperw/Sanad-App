import 'package:flutter/material.dart';
import 'package:sanad/core/helper/responsive_extensions.dart';
import 'package:sanad/core/theme/app_colors.dart';

class SuccessBackgroundWidget extends StatelessWidget {
  const SuccessBackgroundWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Faded large circle (Positioned top-right for RTL)
        Positioned(
          top: -60.h(context),
          right: -40.w(context),
          child: Container(
            height: 250.r(context),
            width: 250.r(context),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryColor.withOpacity(0.05),
            ),
          ),
        ),
        // Slightly darker medium circle overlapping
        Positioned(
          top: -20.h(context),
          right: 20.w(context),
          child: Container(
            height: 140.r(context),
            width: 140.r(context),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryColor.withOpacity(0.1),
            ),
          ),
        ),
      ],
    );
  }
}
