import 'package:flutter/material.dart';
import '../../../../core/constants/app_images.dart'; // تأكد من مسار ملف Assets
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/helper/responsive_extensions.dart';

class AchievementItem {
  final String label;
  final Color color;
  final bool isUnlocked;
  final String? iconAsset;

  const AchievementItem({
    required this.label,
    required this.color,
    this.isUnlocked = true,
    this.iconAsset,
  });
}

class AchievementsCardWidget extends StatelessWidget {
  final String achieved;
  final String total;
  final List<AchievementItem> achievements;

  const AchievementsCardWidget({
    super.key,
    this.achieved = '4',
    this.total = '8',
    this.achievements = const [
      AchievementItem(
        label: 'بطل التوعية',
        color: AppColors.chatChipBorder,
        iconAsset: Assets.iconShield,
      ),
      AchievementItem(
        label: 'المنقذ',
        color: AppColors.orange,
        iconAsset: Assets.iconFavorite,
      ),
      AchievementItem(
        label: '100 ساعة',
        color: AppColors.chatChipBorder,
        iconAsset: Assets.iconTime,
      ),
      AchievementItem(
        label: 'مكتمل التقارير',
        color: Color(0xFF2ECC71),
        iconAsset: Assets.iconDocument,
      ),
      AchievementItem(
        label: 'متطوع الشهر',
        color: AppColors.dividerColor,
        isUnlocked: false,
        iconAsset: Assets.iconLockFilled,
      ),
      AchievementItem(
        label: '50 حملة',
        color: AppColors.dividerColor,
        isUnlocked: false,
        iconAsset: Assets.iconLockFilled,
      ),
    ],
  });

  @override
  Widget build(BuildContext context) {
    final rows = <List<AchievementItem>>[];
    for (var i = 0; i < achievements.length; i += 3) {
      rows.add(
        achievements.sublist(
          i,
          i + 3 > achievements.length ? achievements.length : i + 3,
        ),
      );
    }

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
            blurRadius: 4,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'إنجازاتي🎖',
                style: TextStyles.cairoBold16DarkBlue(context),
              ),
              Text(
                '$achieved / $total محققة',
                style: TextStyles.cairoRegular12Gray(
                  context,
                ).copyWith(color: AppColors.textGray),
              ),
            ],
          ),
          SizedBox(height: 16.h(context)),
          // Grid
          Column(
            children: rows.map((row) {
              return Padding(
                padding: EdgeInsets.only(bottom: 16.h(context)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment
                      .spaceBetween, // لتوزيع المسافات بالتساوي
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: row.map((item) {
                    return _AchievementCell(item: item);
                  }).toList(),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _AchievementCell extends StatelessWidget {
  final AchievementItem item;

  const _AchievementCell({required this.item});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: item.isUnlocked
          ? 1.0
          : 0.5, // تقليل الشفافية للعناصر غير المحققة
      child: SizedBox(
        width: 76.w(context), // تثبيت العرض عشان الكلام ميبوظش التنسيق
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 64.w(context),
              height: 64.w(context),
              decoration: ShapeDecoration(
                color: item.color,
                shape: const CircleBorder(),
              ),
              child: item.iconAsset != null
                  ? Center(
                      child: Image.asset(
                        item.iconAsset!,
                        width: 32.w(context),
                        height: 32.w(context),
                      ),
                    )
                  : const SizedBox(),
            ),
            SizedBox(height: 8.h(context)),
            Text(
              item.label,
              textAlign: TextAlign.center,
              style: TextStyles.cairoRegular10Gray(context).copyWith(
                color: item.isUnlocked
                    ? AppColors.darkBlue
                    : AppColors.textGray,
                fontWeight: item.isUnlocked ? FontWeight.w700 : FontWeight.w600,
                height: 1.20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
