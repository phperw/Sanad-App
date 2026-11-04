import 'package:flutter/material.dart';
import 'package:sanad/core/helper/responsive_extensions.dart';
import 'package:sanad/core/theme/app_colors.dart';
import 'package:sanad/core/theme/text_styles.dart';

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
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
    final defaultStyle = TextStyles.cairoExtraBold18White(
      context,
    ).copyWith(fontSize: 16.sp(context));
    final radius = borderRadius?.r(context) ?? 18.r(context);

    return Container(
      width: width ?? double.infinity,
      height: height ?? 56.h(context),
      decoration: BoxDecoration(
        boxShadow:
            boxShadow ??
            const [
              BoxShadow(
                color: Color(0x24188A55),
                blurRadius: 18,
                offset: Offset(0, 7),
              ),
            ],
        borderRadius: BorderRadius.circular(radius),
      ),
      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor: buttonColor ?? AppColors.primaryColor,
          padding: EdgeInsets.symmetric(horizontal: 18.w(context)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: textStyle ?? defaultStyle,
        ),
      ),
    );
  }
}
