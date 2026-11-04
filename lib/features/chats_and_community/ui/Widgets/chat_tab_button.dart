import 'package:flutter/material.dart';
import '../../../../core/helper/responsive_extensions.dart';
import '../../../../core/helper/spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';

class ChatTabButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isActive;
  final VoidCallback onTap;

  const ChatTabButton({
    super.key,
    required this.label,
    required this.icon,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: 54.h(context),
          decoration: BoxDecoration(
            color: isActive
                ? AppColors.primaryColor.withValues(alpha: 0.12)
                : theme.cardColor,
            border: Border.all(
              color: isActive
                  ? AppColors.primaryColor.withValues(alpha: 0.28)
                  : AppColors.borderThemed(context),
            ),
            borderRadius: BorderRadius.circular(17.r(context)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 20.r(context),
                color: isActive
                    ? AppColors.primaryColor
                    : theme.colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              horizontalSpace(context, width: 7),
              Flexible(
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyles.cairoBold14White(context).copyWith(
                    color: isActive
                        ? AppColors.primaryColor
                        : theme.colorScheme.onSurface.withValues(alpha: 0.7),
                    fontSize: 11.sp(context),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
