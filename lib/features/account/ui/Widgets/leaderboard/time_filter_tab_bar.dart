import 'package:flutter/material.dart';
import 'package:sanad/core/theme/app_colors.dart';
import 'package:sanad/core/theme/text_styles.dart';
import 'package:sanad/core/helper/responsive_extensions.dart';

class TimeFilterTabBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabChanged;

  const TimeFilterTabBar({
    super.key,
    required this.selectedIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    final List<String> tabs = ['أسبوعي', 'شهري', 'كل الوقت'];

    return Container(
      width: double.infinity,
      height: 48.h(context),
      padding: EdgeInsets.all(4.r(context)),
      decoration: BoxDecoration(
        color: AppColors.cardBackground(context),
        borderRadius: BorderRadius.circular(5.r(context)),
        border: Border.all(color: AppColors.borderThemed(context)),
      ),
      child: Row(
        children: List.generate(tabs.length, (index) {
          final isSelected = selectedIndex == index;

          return Expanded(
            child: GestureDetector(
              onTap: () => onTabChanged(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.chatChipBorder
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(14.r(context)),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.shadowColor,
                            blurRadius: 3,
                            offset: const Offset(0, 1),
                          ),
                        ]
                      : [],
                ),
                child: Text(
                  tabs[index],
                  textAlign: TextAlign.center,
                  style: isSelected
                      ? TextStyles.cairoBold14White(context)
                      : TextStyles.cairoBold14Gray(
                          context,
                        ).copyWith(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
