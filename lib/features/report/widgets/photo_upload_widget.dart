import 'package:flutter/material.dart';
import 'package:sanad/core/helper/responsive_extensions.dart';
import 'package:sanad/core/helper/spacing.dart';
import 'package:sanad/core/theme/app_colors.dart';
import 'package:sanad/core/theme/text_styles.dart';

class PhotoUploadWidget extends StatelessWidget {
  const PhotoUploadWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'إرفاق صور ميدانية',
          style: TextStyles.cairoBold32Dark(
            context,
          ).copyWith(fontSize: 16.sp(context), color: onSurface),
        ),
        verticalSpace(context, height: 12),
        InkWell(
          onTap: () {},
          child: Container(
            height: 120.h(context),
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFF3FAF6),
              borderRadius: BorderRadius.circular(16.r(context)),
              border: Border.all(
                color: AppColors.primaryColor.withOpacity(0.6),
                width: 1.5,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.camera_alt_outlined,
                  color: AppColors.primaryColor,
                  size: 32.r(context),
                ),
                verticalSpace(context, height: 8),
                Text(
                  'اضغط لرفع الصور',
                  style: TextStyles.cairoBold32Dark(context).copyWith(
                    fontSize: 14.sp(context),
                    color: AppColors.primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
