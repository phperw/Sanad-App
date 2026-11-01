// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:sanad/core/theme/app_colors.dart';
// import 'package:sanad/core/theme/text_styles.dart';
// import 'package:sanad/core/helper/responsive_extensions.dart';
// import 'package:sanad/core/helper/spacing.dart';
// import 'package:sanad/core/routing/router.dart';

// class SosSuccessScreen extends StatefulWidget {
//   const SosSuccessScreen({super.key});

//   @override
//   State<SosSuccessScreen> createState() => _SosSuccessScreenState();
// }

// class _SosSuccessScreenState extends State<SosSuccessScreen>
//     with SingleTickerProviderStateMixin {
//   int _seconds = 3;
//   Timer? _timer;
//   late AnimationController _checkController;
//   late Animation<double> _checkScale;

//   @override
//   void initState() {
//     super.initState();

//     _checkController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 600),
//     );

//     _checkScale = CurvedAnimation(
//       parent: _checkController,
//       curve: Curves.elasticOut,
//     );

//     _checkController.forward();

//     _timer = Timer.periodic(const Duration(seconds: 1), (t) {
//       if (_seconds == 1) {
//         t.cancel();
//         if (mounted) context.go(AppRouter.kmain);
//       } else {
//         setState(() => _seconds--);
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _timer?.cancel();
//     _checkController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//       body: Stack(
//         children: [
//           _BackgroundPattern(),
//           SafeArea(
//             child: Directionality(
//               textDirection: TextDirection.rtl,
//               child: Padding(
//                 padding: context.responsivePadding(horizontal: 24),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     const Spacer(flex: 2),
//                     ScaleTransition(
//                       scale: _checkScale,
//                       child: Container(
//                         width: 100.w(context),
//                         height: 100.w(context),
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: AppColors.chatChipBorder,
//                           boxShadow: [
//                             BoxShadow(
//                               color: AppColors.chatChipBorder.withOpacity(0.25),
//                               blurRadius: 24,
//                               offset: const Offset(0, 8),
//                             ),
//                           ],
//                         ),
//                         child: Icon(
//                           Icons.check_rounded,
//                           color: Colors.white,
//                           size: 52.sp(context),
//                         ),
//                       ),
//                     ),
//                     verticalSpace(context, height: 32),
//                     Text(
//                       'الحمد لله، أنت بخير',
//                       textAlign: TextAlign.center,
//                       style: TextStyles.cairoBold20Dark(context).copyWith(
//                         fontSize: 22.sp(context),
//                         color: AppColors.darkBlue,
//                       ),
//                     ),
//                     verticalSpace(context, height: 8),
//                     Text(
//                       'تم إيقاف مشاركة موقعك وإغلاق طلب الطوارئ',
//                       textAlign: TextAlign.center,
//                       style: TextStyles.cairoRegular12Gray(context).copyWith(
//                         fontSize: 14.sp(context),
//                         color: AppColors.textGray,
//                         height: 1.6,
//                       ),
//                     ),
//                     verticalSpace(context, height: 32),
//                     Container(
//                       width: double.infinity,
//                       padding: context.responsivePadding(
//                         horizontal: 20,
//                         vertical: 18,
//                       ),
//                       decoration: BoxDecoration(
//                         color: AppColors.cardBackground(context),
//                         borderRadius: BorderRadius.circular(16.r(context)),
//                         boxShadow: const [
//                           BoxShadow(
//                             color: Color(0x19000000),
//                             blurRadius: 8,
//                             offset: Offset(0, 4),
//                           ),
//                         ],
//                       ),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.center,
//                         children: [
//                           Text(
//                             'تم إبلاغ الإدارة بأنك بخير',
//                             textAlign: TextAlign.center,
//                             style: TextStyles.cairoBold16DarkBlue(
//                               context,
//                             ).copyWith(fontSize: 14.sp(context)),
//                           ),
//                           verticalSpace(context, height: 6),
//                           Text(
//                             'سيتم تسجيل الحادثة في سجل الأمان الخاص بك',
//                             textAlign: TextAlign.center,
//                             style: TextStyles.cairoRegular12Gray(context)
//                                 .copyWith(
//                                   fontSize: 12.sp(context),
//                                   color: AppColors.textGray,
//                                 ),
//                           ),
//                         ],
//                       ),
//                     ),
//                     const Spacer(flex: 2),
//                     Text(
//                       'سيتم الانتقال للرئيسية خلال $_seconds ثانية',
//                       textAlign: TextAlign.center,
//                       style: TextStyles.cairoRegular12Gray(context).copyWith(
//                         fontSize: 13.sp(context),
//                         color: AppColors.textGray,
//                       ),
//                     ),
//                     verticalSpace(context, height: 10),
//                     _CountdownBar(seconds: _seconds, total: 3),
//                     verticalSpace(context, height: 16),
//                     GestureDetector(
//                       onTap: () {
//                         _timer?.cancel();
//                         context.go(AppRouter.kmain);
//                       },
//                       child: Text(
//                         'العودة للرئيسية الآن',
//                         textAlign: TextAlign.center,
//                         style: TextStyles.cairoBold14Primary(context).copyWith(
//                           color: AppColors.chatChipBorder,
//                           fontSize: 14.sp(context),
//                           decoration: TextDecoration.underline,
//                           decorationColor: AppColors.chatChipBorder,
//                         ),
//                       ),
//                     ),
//                     verticalSpace(context, height: 32),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

// class _CountdownBar extends StatelessWidget {
//   final int seconds;
//   final int total;

//   const _CountdownBar({required this.seconds, required this.total});

//   @override
//   Widget build(BuildContext context) {
//     return ClipRRect(
//       borderRadius: BorderRadius.circular(100),
//       child: LinearProgressIndicator(
//         value: seconds / total,
//         minHeight: 4,
//         backgroundColor: AppColors.chatChipBorder.withOpacity(0.15),
//         valueColor: const AlwaysStoppedAnimation<Color>(
//           AppColors.chatChipBorder,
//         ),
//       ),
//     );
//   }
// }

// class _BackgroundPattern extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final ringColor = isDark
//         ? AppColors.chatChipBorder.withOpacity(0.06)
//         : AppColors.chatChipBorder.withOpacity(0.07);

//     return Positioned(
//       top: -80,
//       left: -80,
//       child: CustomPaint(
//         size: Size(380.w(context), 380.w(context)),
//         painter: _RingsPainter(color: ringColor),
//       ),
//     );
//   }
// }

// class _RingsPainter extends CustomPainter {
//   final Color color;
//   _RingsPainter({required this.color});

//   @override
//   void paint(Canvas canvas, Size size) {
//     final paint = Paint()
//       ..color = color
//       ..style = PaintingStyle.stroke
//       ..strokeWidth = 1.5;

//     final center = Offset(size.width / 2, size.height / 2);
//     for (var i = 1; i <= 4; i++) {
//       canvas.drawCircle(center, size.width * 0.15 * i, paint);
//     }
//   }

//   @override
//   bool shouldRepaint(_RingsPainter old) => old.color != color;
// }
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sanad/core/theme/app_colors.dart';
import 'package:sanad/core/theme/text_styles.dart';
import 'package:sanad/core/helper/responsive_extensions.dart';
import 'package:sanad/core/helper/spacing.dart';
import 'package:sanad/core/routing/router.dart';

class SosSuccessScreen extends StatefulWidget {
  const SosSuccessScreen({super.key});

  @override
  State<SosSuccessScreen> createState() => _SosSuccessScreenState();
}

class _SosSuccessScreenState extends State<SosSuccessScreen>
    with SingleTickerProviderStateMixin {
  int _seconds = 3;
  Timer? _timer;
  late AnimationController _checkController;
  late Animation<double> _checkScale;

  @override
  void initState() {
    super.initState();

    _checkController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _checkScale = CurvedAnimation(
      parent: _checkController,
      curve: Curves.elasticOut,
    );

    _checkController.forward();

    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (_seconds == 1) {
        t.cancel();
        if (mounted) context.go(AppRouter.kmain);
      } else {
        setState(() => _seconds--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _checkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Stack(
        children: [
          _BackgroundPattern(),
          SafeArea(
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Padding(
                padding: context.responsivePadding(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Spacer(flex: 2),
                    ScaleTransition(
                      scale: _checkScale,
                      child: Container(
                        width: 100.w(context),
                        height: 100.w(context),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.chatChipBorder,
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.chatChipBorder.withOpacity(0.25),
                              blurRadius: 24,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.check_rounded,
                          color: Colors.white,
                          size: 52.sp(context),
                        ),
                      ),
                    ),
                    verticalSpace(context, height: 32),
                    Text(
                      'الحمد لله، أنت بخير',
                      textAlign: TextAlign.center,
                      style: TextStyles.cairoBold20Dark(context).copyWith(
                        fontSize: 22.sp(context),
                        color: AppColors.darkBlue,
                      ),
                    ),
                    verticalSpace(context, height: 8),
                    Text(
                      'تم إيقاف مشاركة موقعك وإغلاق طلب الطوارئ',
                      textAlign: TextAlign.center,
                      style: TextStyles.cairoRegular12Gray(context).copyWith(
                        fontSize: 14.sp(context),
                        color: AppColors.textGray,
                        height: 1.6,
                      ),
                    ),
                    verticalSpace(context, height: 32),
                    Container(
                      width: double.infinity,
                      padding: context.responsivePadding(
                        horizontal: 20,
                        vertical: 18,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.cardBackground(context),
                        borderRadius: BorderRadius.circular(16.r(context)),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x19000000),
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'تم إبلاغ الإدارة بأنك بخير',
                            textAlign: TextAlign.center,
                            style: TextStyles.cairoBold16DarkBlue(
                              context,
                            ).copyWith(fontSize: 14.sp(context)),
                          ),
                          verticalSpace(context, height: 6),
                          Text(
                            'سيتم تسجيل الحادثة في سجل الأمان الخاص بك',
                            textAlign: TextAlign.center,
                            style: TextStyles.cairoRegular12Gray(context)
                                .copyWith(
                                  fontSize: 12.sp(context),
                                  color: AppColors.textGray,
                                ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(flex: 2),
                    Text(
                      'سيتم الانتقال للرئيسية خلال $_seconds ثانية',
                      textAlign: TextAlign.center,
                      style: TextStyles.cairoRegular12Gray(context).copyWith(
                        fontSize: 13.sp(context),
                        color: AppColors.textGray,
                      ),
                    ),
                    verticalSpace(context, height: 10),
                    _CountdownBar(seconds: _seconds, total: 3),
                    verticalSpace(context, height: 16),
                    GestureDetector(
                      onTap: () {
                        _timer?.cancel();
                        context.go(AppRouter.kmain);
                      },
                      child: Text(
                        'العودة للرئيسية الآن',
                        textAlign: TextAlign.center,
                        style: TextStyles.cairoBold14Primary(context).copyWith(
                          color: AppColors.chatChipBorder,
                          fontSize: 14.sp(context),
                          decoration: TextDecoration.underline,
                          decorationColor: AppColors.chatChipBorder,
                        ),
                      ),
                    ),
                    verticalSpace(context, height: 32),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CountdownBar extends StatelessWidget {
  final int seconds;
  final int total;

  const _CountdownBar({required this.seconds, required this.total});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: LinearProgressIndicator(
        value: seconds / total,
        minHeight: 4,
        backgroundColor: AppColors.chatChipBorder.withOpacity(0.15),
        valueColor: const AlwaysStoppedAnimation<Color>(
          AppColors.chatChipBorder,
        ),
      ),
    );
  }
}

class _BackgroundPattern extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final ringColor = isDark
        ? AppColors.chatChipBorder.withOpacity(0.06)
        : AppColors.chatChipBorder.withOpacity(0.07);

    return Positioned(
      top: -80,
      left: -80,
      child: CustomPaint(
        size: Size(380.w(context), 380.w(context)),
        painter: _RingsPainter(color: ringColor),
      ),
    );
  }
}

class _RingsPainter extends CustomPainter {
  final Color color;
  _RingsPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final center = Offset(size.width / 2, size.height / 2);
    for (var i = 1; i <= 4; i++) {
      canvas.drawCircle(center, size.width * 0.15 * i, paint);
    }
  }

  @override
  bool shouldRepaint(_RingsPainter old) => old.color != color;
}
