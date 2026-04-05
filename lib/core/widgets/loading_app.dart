import 'package:flutter/material.dart';
import '../helper/spacing.dart';
import '../theme/app_colors.dart';
import '../theme/text_styles.dart';
import '../helper/responsive_extensions.dart';

class LoadingApp extends StatelessWidget {
  const LoadingApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        color: Colors.black.withOpacity(0.4),
        child: const Center(
          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3),
        ),
      ),
    );
  }
}

void showLoadingDialog(BuildContext context, {String? message}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    barrierColor: Colors.black.withOpacity(0.4),
    builder: (_) => _LoadingDialog(message: message),
  );
}

class _LoadingDialog extends StatelessWidget {
  const _LoadingDialog({this.message});

  final String? message;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = Theme.of(context).cardColor;
    final shadowColor = isDark
        ? Colors.black.withOpacity(0.4)
        : AppColors.dark.withOpacity(0.12);

    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 28.w(context),
          vertical: 24.h(context),
        ),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(20.r(context)),
          boxShadow: [
            BoxShadow(
              color: shadowColor,
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              message ?? 'جاري تسجيل الدخول',
              style: TextStyles.cairoMedium14Black(
                context,
              ).copyWith(color: Theme.of(context).colorScheme.onSurface),
            ),
            horizontalSpace(context, width: 16),
            SizedBox(
              width: 24.w(context),
              height: 24.h(context),
              child: CircularProgressIndicator(
                color: AppColors.primaryColor,
                strokeWidth: 2.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
