import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sanad/core/theme/app_colors.dart';
import 'package:sanad/core/theme/text_styles.dart';
import 'package:sanad/core/helper/responsive_extensions.dart';
import 'package:sanad/core/helper/spacing.dart';
import 'package:sanad/core/routing/router.dart';

class SosAlertDialog extends StatefulWidget {
  const SosAlertDialog({super.key});

  @override
  State<SosAlertDialog> createState() => _SosAlertDialogState();
}

class _SosAlertDialogState extends State<SosAlertDialog>
    with SingleTickerProviderStateMixin {
  int _seconds = 5;
  bool _triggered = false;
  Timer? _timer;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      if (_seconds <= 1) {
        t.cancel();
        _triggerSos();
      } else {
        setState(() => _seconds--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  void _triggerSos() {
    if (_triggered) return;
    _triggered = true;
    _timer?.cancel();
    final router = GoRouter.of(context);
    Navigator.of(context).pop();
    router.push(AppRouter.kSosSending);
  }

  void _cancel() {
    _timer?.cancel();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF1E1E1E) : const Color(0xFFFAFAFA);
    final titleColor = isDark ? Colors.white : const Color(0xFF1A1A1A);
    final subtitleColor = isDark
        ? const Color(0xFFAAAAAA)
        : const Color(0xFFA0A0A0);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w(context)),
      child: Container(
        padding: EdgeInsets.fromLTRB(
          20.w(context),
          28.h(context),
          20.w(context),
          20.h(context),
        ),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(24.r(context)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.4 : 0.12),
              blurRadius: 24,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ScaleTransition(
                scale: _pulseAnimation,
                child: Container(
                  width: 56.w(context),
                  height: 56.w(context),
                  decoration: BoxDecoration(
                    color: AppColors.sosRed,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.sosRed.withOpacity(0.35),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.white,
                    size: 28.sp(context),
                  ),
                ),
              ),
              verticalSpace(context, height: 16),
              Text(
                'هل أنت في خطر؟',
                textAlign: TextAlign.center,
                style: TextStyles.cairoBold20Dark(
                  context,
                ).copyWith(color: titleColor),
              ),
              verticalSpace(context, height: 6),
              Text(
                'سيتم إرسال موقعك فوراً للإدارة\nوللمتطوعين القريبين منك',
                textAlign: TextAlign.center,
                style: TextStyles.cairoRegular10Gray(context).copyWith(
                  fontSize: 12.sp(context),
                  color: subtitleColor,
                  height: 1.6,
                ),
              ),
              verticalSpace(context, height: 24),
              Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 80.w(context),
                    height: 80.w(context),
                    child: CircularProgressIndicator(
                      value: _seconds / 5,
                      strokeWidth: 5,
                      backgroundColor: AppColors.sosRed.withOpacity(
                        isDark ? 0.2 : 0.12,
                      ),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.sosRed,
                      ),
                    ),
                  ),
                  Text(
                    '$_seconds',
                    style: TextStyles.cairoBold32Black(context).copyWith(
                      fontSize: 34.sp(context),
                      color: AppColors.sosRed,
                    ),
                  ),
                ],
              ),
              verticalSpace(context, height: 6),
              Text(
                'سيتم الإرسال تلقائياً بعد',
                textAlign: TextAlign.center,
                style: TextStyles.cairoRegular10Gray(
                  context,
                ).copyWith(color: subtitleColor, fontSize: 11.sp(context)),
              ),
              verticalSpace(context, height: 24),
              GestureDetector(
                onTap: _triggerSos,
                child: Container(
                  width: double.infinity,
                  height: 50.h(context),
                  decoration: BoxDecoration(
                    color: AppColors.sosRed,
                    borderRadius: BorderRadius.circular(14.r(context)),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.sosRed.withOpacity(0.35),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.white,
                        size: 20.sp(context),
                      ),
                      horizontalSpace(context, width: 8),
                      Text(
                        'إرسال طلب الطوارئ الآن',
                        style: TextStyles.cairoSemiBold12White(context)
                            .copyWith(
                              fontSize: 13.sp(context),
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              verticalSpace(context, height: 10),
              GestureDetector(
                onTap: _cancel,
                child: Container(
                  width: double.infinity,
                  height: 48.h(context),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.sosRed.withOpacity(0.08)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(14.r(context)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'إلغاء — أنا بخير',
                        style: TextStyles.cairoBold14Primary(
                          context,
                        ).copyWith(fontSize: 13.sp(context)),
                      ),
                      horizontalSpace(context, width: 8),
                      Icon(
                        Icons.sentiment_satisfied_alt,
                        color: AppColors.primaryColor,
                        size: 20.sp(context),
                      ),
                    ],
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