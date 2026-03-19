import 'package:flutter/material.dart';
import 'package:sanad/core/helper/responsive_extensions.dart';
import 'package:sanad/core/helper/spacing.dart';
import 'package:sanad/core/theme/app_colors.dart';
import 'package:sanad/core/theme/text_styles.dart';

class SearchBarWidget extends StatelessWidget {
  const SearchBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: context.responsivePadding(horizontal: 16, top: 16),
        child: Row(
          children: [
            // The Search Input Field
            Expanded(
              child: Container(
                height: 50.h(context),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(12.r(context)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'ابحث عن مهام قريبة منك...',
                    hintStyle: TextStyles.cairoRegular14Muted(context),
                    prefixIcon: Icon(
                      Icons.search,
                      size: 20.r(context),
                      color: AppColors.gray,
                    ),
                    border: InputBorder.none,
                    contentPadding: context.responsivePadding(vertical: 14),
                  ),
                ),
              ),
            ),
            horizontalSpace(context, width: 12),

            // The Action Button (Arrow)
            Container(
              height: 50.h(context),
              width: 50.w(context),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12.r(context)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Center(
                child: Icon(
                  Icons.arrow_forward_ios,
                  size: 18.r(context),
                  color: AppColors.dark,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
