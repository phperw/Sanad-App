import 'package:flutter/material.dart';
import 'package:sanad/core/helper/responsive_extensions.dart';
import 'package:sanad/core/helper/spacing.dart';
import 'package:sanad/core/theme/app_colors.dart';
import 'package:sanad/core/theme/text_styles.dart';

class CampaignNotesInputWidget extends StatelessWidget {
  const CampaignNotesInputWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final cardColor = Theme.of(context).cardColor;
    final dividerColor = Theme.of(context).dividerColor;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'ملاحظات الحملة',
              style: TextStyles.cairoBold32Dark(
                context,
              ).copyWith(fontSize: 16.sp(context), color: onSurface),
            ),
            horizontalSpace(context, width: 8),
            Container(
              padding: context.responsivePadding(horizontal: 10, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFE4F3EB),
                borderRadius: BorderRadius.circular(20.r(context)),
              ),
              child: Text(
                'إلزامي',
                style: TextStyles.cairoBold32Dark(context).copyWith(
                  fontSize: 10.sp(context),
                  color: AppColors.primaryColor,
                ),
              ),
            ),
          ],
        ),
        verticalSpace(context, height: 12),
        Container(
          height: 160.h(context),
          decoration: BoxDecoration(
            color: cardColor,
            borderRadius: BorderRadius.circular(16.r(context)),
            border: Border.all(color: dividerColor),
          ),
          child: Stack(
            children: [
              TextField(
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'اكتب تفاصيل الحملة هنا أو استخدم المايك...',
                  hintStyle: TextStyles.cairoRegular14Muted(
                    context,
                  ).copyWith(fontSize: 12.sp(context)),
                  border: InputBorder.none,
                  contentPadding: context.responsivePadding(all: 16),
                ),
              ),
              Positioned(
                bottom: 16.h(context),
                left: 0,
                right: 0,
                child: Center(
                  child: InkWell(
                    onTap: () {},
                    child: Container(
                      height: 50.r(context),
                      width: 50.r(context),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryColor.withOpacity(0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.mic,
                        color: AppColors.white,
                        size: 24.r(context),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
