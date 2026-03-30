import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/helper/responsive_extensions.dart';

class CertificateItem {
  final String title;
  final String date;
  final String? iconAsset;

  const CertificateItem({
    required this.title,
    required this.date,
    this.iconAsset,
  });
}

class CertificatesCardWidget extends StatelessWidget {
  final String count;
  final List<CertificateItem> certificates;

  const CertificatesCardWidget({
    super.key,
    this.count = '2',
    this.certificates = const [
      CertificateItem(
        title: 'شهادة تقدير — 100 ساعة تطوع',
        date: 'فبراير 2026',
      ),
    ],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 20.w(context),
        vertical: 20.h(context),
      ),
      decoration: ShapeDecoration(
        color: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r(context)),
        ),
        shadows: const [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: certificates.map((cert) {
          return Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cert.title,
                      style: TextStyles.cairoBold14Black2(context),
                    ),
                    SizedBox(height: 4.h(context)),
                    Text(
                      cert.date,
                      style: TextStyles.cairoRegular12Gray(context),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 12.w(context)),
              Container(
                width: 36.w(context),
                height: 36.w(context),
                decoration: ShapeDecoration(
                  color: AppColors.chatChipBorder,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100.r(context)),
                  ),
                ),
                child: cert.iconAsset != null
                    ? Center(
                        child: Image.asset(
                          cert.iconAsset!,
                          width: 20.w(context),
                        ),
                      )
                    : Icon(
                        Icons.workspace_premium_rounded,
                        color: AppColors.white,
                        size: 18.w(context),
                      ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
