import 'package:flutter/material.dart';
import '../../../../core/helper/responsive_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/text_styles.dart';
import 'package:solar_icons/solar_icons.dart';

class ChatHeader extends StatelessWidget {
  final String title;
  const ChatHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: Text(
                title,
                key: ValueKey(title),
                textAlign: TextAlign.center,
                style: TextStyles.cairoBold20DarkBlue(context).copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 19.sp(context),
                ),
              ),
            ),
          ),
          Container(
            width: 42.r(context),
            height: 42.r(context),
            decoration: BoxDecoration(
              color: AppColors.primaryColor.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              SolarIconsOutline.bell,
              color: AppColors.primaryColor,
              size: 21.r(context),
            ),
          ),
        ],
      ),
    );
  }
}
