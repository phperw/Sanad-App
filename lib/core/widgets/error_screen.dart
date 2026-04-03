import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sanad/core/constants/app_images.dart';
import 'package:sanad/core/helper/responsive_extensions.dart';
import 'package:sanad/core/helper/spacing.dart';
import 'package:sanad/core/theme/app_colors.dart';
import 'package:sanad/core/theme/text_styles.dart';

import '../helper/shared_pref_helper.dart';
import '../routing/router.dart';

class ErrorScreen extends StatefulWidget {
  final String? message;
  final VoidCallback? onRetry;

  const ErrorScreen({super.key, this.message, this.onRetry});

  @override
  State<ErrorScreen> createState() => _ErrorScreenState();
}

class _ErrorScreenState extends State<ErrorScreen>
    with TickerProviderStateMixin {
  late AnimationController _floatController;
  late AnimationController _fadeController;
  late AnimationController _buttonController;

  late Animation<double> _floatAnim;
  late Animation<double> _fadeAnim;
  late Animation<double> _buttonScale;

  @override
  void initState() {
    super.initState();

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat(reverse: true);

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();

    _buttonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 120),
    );

    _floatAnim = Tween<double>(begin: -10, end: 10).animate(
      CurvedAnimation(parent: _floatController, curve: Curves.easeInOut),
    );

    _fadeAnim = CurvedAnimation(parent: _fadeController, curve: Curves.easeOut);

    _buttonScale = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _floatController.dispose();
    _fadeController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  String _resolveSubtitle() {
    final msg = widget.message?.toLowerCase() ?? '';
    if (msg.contains('401') ||
        msg.contains('تسجيل الدخول') ||
        msg.contains('unauthorized')) {
      return 'انتهت صلاحية الجلسة، يرجى تسجيل الدخول مجدداً';
    }
    if (msg.contains('إنترنت') ||
        msg.contains('internet') ||
        msg.contains('connection')) {
      return 'تأكد من اتصالك بالإنترنت وحاول مرة أخرى';
    }
    if (msg.contains('timeout') || msg.contains('مهلة')) {
      return 'استغرق الطلب وقتاً طويلاً، حاول مجدداً';
    }
    if (msg.contains('500') ||
        msg.contains('server') ||
        msg.contains('سيرفر')) {
      return 'هناك مشكلة في الخادم، حاول لاحقاً';
    }
    return '(Opps! Something went wrong.)';
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fadeAnim,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 32.w(context)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AnimatedBuilder(
                animation: _floatAnim,
                builder: (context, child) => Transform.translate(
                  offset: Offset(0, _floatAnim.value),
                  child: child,
                ),
                child: Image.asset(
                  Assets.errorRobot,
                  width: 220.w(context),
                  fit: BoxFit.contain,
                ),
              ),
              verticalSpace(context, height: 28),
              Text(
                'حدثت مشكلة ما',
                style: TextStyles.cairoBold20DarkBlue(context),
                textAlign: TextAlign.center,
              ),
              verticalSpace(context, height: 8),
              Text(
                _resolveSubtitle(),
                style: TextStyles.cairoRegular14Muted(context),
                textAlign: TextAlign.center,
              ),
              verticalSpace(context, height: 36),
              if (widget.onRetry != null)
                // GestureDetector(
                //   // onTapDown: (_) => _buttonController.forward(),
                //   onTapUp: (_) {
                //     // _buttonController.reverse();
                //     context.go(AppRouter.kstart);
                //   },
                //   onTapCancel: () => _buttonController.reverse(),
                //   child: ScaleTransition(
                //     scale: _buttonScale,
                //     child: Container(
                //       width: double.infinity,
                //       height: 56.h(context),
                //       decoration: BoxDecoration(
                //         color: AppColors.primaryColor,
                //         borderRadius: BorderRadius.circular(16.r(context)),
                //         boxShadow: [
                //           BoxShadow(
                //             color: AppColors.primaryColor.withOpacity(0.3),
                //             blurRadius: 16,
                //             offset: const Offset(0, 6),
                //           ),
                //         ],
                //       ),
                //       child: Row(
                //         mainAxisAlignment: MainAxisAlignment.center,
                //         children: [
                //           const Icon(
                //             Icons.refresh_rounded,
                //             color: AppColors.white,
                //             size: 20,
                //           ),
                //           horizontalSpace(context, width: 8),
                //           Text(
                //             'حاول مرة أخرى',
                //             style: TextStyles.cairoBold16White(context),
                //           ),
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
                GestureDetector(
                  onTapDown: (_) => _buttonController.forward(),
                  onTapUp: (_) async {
                    _buttonController.reverse();

                    await SharedPrefHelper.clearTokens();

                    // await SharedPrefHelper.clearAll();

                    context.go(AppRouter.klogin);
                  },
                  onTapCancel: () => _buttonController.reverse(),
                  child: ScaleTransition(
                    scale: _buttonScale,
                    child: Container(
                      width: double.infinity,
                      height: 56.h(context),
                      decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(16.r(context)),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primaryColor.withOpacity(0.3),
                            blurRadius: 16,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.logout,
                            color: AppColors.white,
                            size: 20,
                          ),
                          horizontalSpace(context, width: 8),
                          Text(
                            'تسجيل خروج',
                            style: TextStyles.cairoBold16White(context),
                          ),
                        ],
                      ),
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
