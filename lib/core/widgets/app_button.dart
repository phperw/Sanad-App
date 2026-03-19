import 'package:flutter/material.dart';
import 'package:sanad/core/helper/responsive_extensions.dart';
import 'package:sanad/core/theme/app_colors.dart';
import 'package:sanad/core/theme/text_styles.dart';

class AppButton extends StatelessWidget {
  final String text;
  // 1. Made this nullable (?) so we can pass 'null' to disable the button natively!
  final VoidCallback? onPressed;
  final double? width;
  final double? height;
  final TextStyle? textStyle;
  final Color? buttonColor;
  final List<BoxShadow>? boxShadow;
  final double? borderRadius;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.width,
    this.height,
    this.textStyle,
    this.buttonColor,
    this.boxShadow,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    final defaultStyle = TextStyles.cairoExtraBold18White(context);

    return Container(
      width: width ?? double.infinity,
      height: height ?? 60.h(context),
      decoration: BoxDecoration(
        boxShadow:
            boxShadow ??
            const [
              BoxShadow(
                color:
                    AppColors.buttonShadow, // Assumes this is in your AppColors
                blurRadius: 20,
                offset: Offset(0, 4),
              ),
            ],
        borderRadius: BorderRadius.circular(
          borderRadius?.r(context) ?? 16.r(context),
        ),
      ),
      // 2. Upgraded to ElevatedButton so it fills the container and handles taps perfectly
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor ?? AppColors.primaryColor,
          disabledBackgroundColor: const Color(
            0xFFE5E7EB,
          ), // Turns grey automatically when onPressed is null
          shadowColor:
              Colors.transparent, // Lets the container handle the shadow
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              borderRadius?.r(context) ?? 16.r(context),
            ),
          ),
        ),
        onPressed: onPressed, // If this is null, the button disables itself!
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: textStyle ?? defaultStyle,
        ),
      ),
    );
  }
}
