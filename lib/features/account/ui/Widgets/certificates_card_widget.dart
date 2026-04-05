import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/helper/responsive_extensions.dart';
import '../../data/models/get_user_card/profile_response.dart';

class CertificatesCardWidget extends StatelessWidget {
  final List<CertificateItem> certificates;

  const CertificatesCardWidget({super.key, this.certificates = const []});

  @override
  Widget build(BuildContext context) {
    final cardColor = Theme.of(context).cardColor;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 20.w(context),
        vertical: 20.h(context),
      ),
      decoration: ShapeDecoration(
        color: cardColor,
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
                      style: TextStyles.cairoBold14Black2(
                        context,
                      ).copyWith(color: onSurface),
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
                child: Center(
                  child: Icon(
                    Icons.workspace_premium_rounded,
                    color: AppColors.white,
                    size: 18.w(context),
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}
