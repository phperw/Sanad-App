import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import '../../../../core/helper/responsive_extensions.dart';

class _StatItem {
  final String value;
  final String label;
  final Color valueColor;
  final bool isSelected;

  const _StatItem({
    required this.value,
    required this.label,
    required this.valueColor,
    this.isSelected = false,
  });
}

class StatsCardWidget extends StatelessWidget {
  final String points;
  final String campaigns;
  final String hours;
  final int selectedIndex;

  const StatsCardWidget({
    super.key,
    this.points = '470',
    this.campaigns = '18',
    this.hours = '120',
    this.selectedIndex = 1,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      _StatItem(value: points, label: 'نقطة', valueColor: AppColors.orange),
      _StatItem(
        value: campaigns,
        label: 'حملة منجزة',
        valueColor: AppColors.chatChipBorder,
        isSelected: selectedIndex == 1,
      ),
      _StatItem(
        value: hours,
        label: 'ساعة تطوع',
        valueColor: AppColors.chatChipBorder,
      ),
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: 16.w(context),
        vertical: 16.h(context),
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(5, (index) {
          if (index % 2 != 0) {
            return Container(
              width: 1,
              height: 40.h(context),
              color: AppColors.dividerColor,
            );
          }
          final item = items[index ~/ 2];
          return Expanded(child: _StatCell(item: item));
        }),
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  final _StatItem item;

  const _StatCell({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (item.isSelected)
          Container(
            height: 4.h(context),
            width: 64.w(context),
            decoration: BoxDecoration(
              color: AppColors.chatChipBorder,
              borderRadius: BorderRadius.circular(100.r(context)),
            ),
          ),
        SizedBox(height: item.isSelected ? 4.h(context) : 8.h(context)),
        Text(
          item.value,
          style: TextStyles.cairoBold24Primary(
            context,
          ).copyWith(color: item.valueColor),
        ),
        Text(
          item.label,
          style: TextStyles.cairoRegular12Gray(
            context,
          ).copyWith(color: AppColors.textGray),
        ),
      ],
    );
  }
}
