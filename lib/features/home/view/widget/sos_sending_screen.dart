// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:go_router/go_router.dart';
// import 'package:sanad/core/theme/app_colors.dart';
// import 'package:sanad/core/theme/text_styles.dart';
// import 'package:sanad/core/helper/responsive_extensions.dart';
// import 'package:sanad/core/helper/spacing.dart';
// import 'package:sanad/core/routing/router.dart';

// class SosSendingScreen extends StatefulWidget {
//   const SosSendingScreen({super.key});

//   @override
//   State<SosSendingScreen> createState() => _SosSendingScreenState();
// }

// class _SosSendingScreenState extends State<SosSendingScreen>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _pulseController;
//   late Animation<double> _pulseAnimation;

//   @override
//   void initState() {
//     super.initState();

//     _pulseController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1000),
//     )..repeat(reverse: true);

//     _pulseAnimation = Tween<double>(begin: 0.85, end: 1.15).animate(
//       CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
//     );

//     Future.delayed(const Duration(seconds: 3), () {
//       if (mounted) context.go(AppRouter.kSosActive);
//     });
//   }

//   @override
//   void dispose() {
//     _pulseController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColors.sosRed,
//       body: SafeArea(
//         child: Directionality(
//           textDirection: TextDirection.rtl,
//           child: Padding(
//             padding: context.responsivePadding(horizontal: 24),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 const Spacer(flex: 2),
//                 ScaleTransition(
//                   scale: _pulseAnimation,
//                   child: Container(
//                     width: 100.w(context),
//                     height: 100.w(context),
//                     decoration: BoxDecoration(
//                       shape: BoxShape.circle,
//                       color: Colors.white.withOpacity(0.15),
//                     ),
//                     child: Center(
//                       child: Container(
//                         width: 72.w(context),
//                         height: 72.w(context),
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: Colors.white.withOpacity(0.2),
//                         ),
//                         child: Icon(
//                           Icons.location_on_rounded,
//                           color: Colors.white,
//                           size: 40.sp(context),
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//                 verticalSpace(context, height: 48),
//                 Text(
//                   'جاري إرسال طلب الطوارئ...',
//                   textAlign: TextAlign.center,
//                   style: TextStyles.cairoBold20Dark(
//                     context,
//                   ).copyWith(color: Colors.white, fontSize: 24.sp(context)),
//                 ),
//                 verticalSpace(context, height: 12),
//                 Text(
//                   'يتم مشاركة موقعك الآن',
//                   textAlign: TextAlign.center,
//                   style: TextStyles.cairoRegular14Muted(context).copyWith(
//                     color: Colors.white.withOpacity(0.85),
//                     fontSize: 14.sp(context),
//                   ),
//                 ),
//                 const Spacer(flex: 3),
//                 Text(
//                   'لا تغلق التطبيق',
//                   textAlign: TextAlign.center,
//                   style: TextStyles.cairoBold20Dark(
//                     context,
//                   ).copyWith(color: Colors.white, fontSize: 20.sp(context)),
//                 ),
//                 verticalSpace(context, height: 32),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:sanad/core/theme/app_colors.dart';
// import 'package:sanad/core/theme/text_styles.dart';
// import 'package:sanad/core/helper/responsive_extensions.dart';
// import 'package:sanad/core/helper/spacing.dart';
// import 'package:sanad/features/home/view/widget/sos_bloc_listener.dart';
// import '../../logic/OSO_Cubit/sos_cubit.dart';

// class SosSendingScreen extends StatefulWidget {
//   const SosSendingScreen({super.key});

//   @override
//   State<SosSendingScreen> createState() => _SosSendingScreenState();
// }

// class _SosSendingScreenState extends State<SosSendingScreen>
//     with SingleTickerProviderStateMixin {
//   late AnimationController _pulseController;
//   late Animation<double> _pulseAnimation;

//   @override
//   void initState() {
//     super.initState();

//     _pulseController = AnimationController(
//       vsync: this,
//       duration: const Duration(milliseconds: 1000),
//     )..repeat(reverse: true);

//     _pulseAnimation = Tween<double>(begin: 0.85, end: 1.15).animate(
//       CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
//     );

//     context.read<SosCubit>().sendSos();
//   }

//   @override
//   void dispose() {
//     _pulseController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return SosBlocListener(
//       child: Scaffold(
//         backgroundColor: AppColors.sosRed,
//         body: SafeArea(
//           child: Directionality(
//             textDirection: TextDirection.rtl,
//             child: Padding(
//               padding: context.responsivePadding(horizontal: 24),
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 crossAxisAlignment: CrossAxisAlignment.center,
//                 children: [
//                   const Spacer(flex: 2),
//                   ScaleTransition(
//                     scale: _pulseAnimation,
//                     child: Container(
//                       width: 100.w(context),
//                       height: 100.w(context),
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: Colors.white.withOpacity(0.15),
//                       ),
//                       child: Center(
//                         child: Container(
//                           width: 72.w(context),
//                           height: 72.w(context),
//                           decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             color: Colors.white.withOpacity(0.2),
//                           ),
//                           child: Icon(
//                             Icons.location_on_rounded,
//                             color: Colors.white,
//                             size: 40.sp(context),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   verticalSpace(context, height: 48),
//                   Text(
//                     'جاري إرسال طلب الطوارئ...',
//                     textAlign: TextAlign.center,
//                     style: TextStyles.cairoBold20Dark(
//                       context,
//                     ).copyWith(color: Colors.white, fontSize: 24.sp(context)),
//                   ),
//                   verticalSpace(context, height: 12),
//                   Text(
//                     'يتم مشاركة موقعك الآن',
//                     textAlign: TextAlign.center,
//                     style: TextStyles.cairoRegular14Muted(context).copyWith(
//                       color: Colors.white.withOpacity(0.85),
//                       fontSize: 14.sp(context),
//                     ),
//                   ),
//                   const Spacer(flex: 3),
//                   Text(
//                     'لا تغلق التطبيق',
//                     textAlign: TextAlign.center,
//                     style: TextStyles.cairoBold20Dark(
//                       context,
//                     ).copyWith(color: Colors.white, fontSize: 20.sp(context)),
//                   ),
//                   verticalSpace(context, height: 32),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanad/core/theme/app_colors.dart';
import 'package:sanad/core/theme/text_styles.dart';
import 'package:sanad/core/helper/responsive_extensions.dart';
import 'package:sanad/core/helper/spacing.dart';
import 'package:sanad/core/networking/dio_factory.dart';
import '../../data/OSO_api_service/sos_api_service.dart';
import '../../data/repo/OSO/sos_repository.dart';
import '../../logic/OSO_Cubit/sos_cubit.dart';
import 'sos_bloc_listener.dart';

class SosSendingScreen extends StatelessWidget {
  const SosSendingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = SosCubit(
          SosRepository(SosApiService(DioFactory.getDio())),
        );
        cubit.sendSos();
        return cubit;
      },
      child: const _SosSendingScreenContent(),
    );
  }
}

class _SosSendingScreenContent extends StatelessWidget {
  const _SosSendingScreenContent();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SosBlocListener(
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Stack(
          children: [
            Positioned(
              bottom: -100,
              left: -100,
              child: CustomPaint(
                size: Size(400.w(context), 400.w(context)),
                painter: _RingsPainter(
                  color: AppColors.sosRed.withOpacity(isDark ? 0.05 : 0.06),
                ),
              ),
            ),
            Center(
              child: Directionality(
                textDirection: TextDirection.rtl,
                child: BlocBuilder<SosCubit, SosState>(
                  builder: (context, state) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 100.w(context),
                          height: 100.w(context),
                          decoration: BoxDecoration(
                            color: AppColors.sosRed.withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Container(
                              width: 70.w(context),
                              height: 70.w(context),
                              decoration: BoxDecoration(
                                color: AppColors.sosRed,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.sosRed.withOpacity(0.4),
                                    blurRadius: 20,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 3,
                                ),
                              ),
                            ),
                          ),
                        ),
                        verticalSpace(context, height: 32),
                        Text(
                          'جاري إرسال طلب الطوارئ...',
                          textAlign: TextAlign.center,
                          style: TextStyles.cairoBold20Dark(context).copyWith(
                            fontSize: 22.sp(context),
                            color: isDark ? Colors.white : AppColors.darkBlue,
                          ),
                        ),
                        verticalSpace(context, height: 8),
                        Text(
                          'يرجى الانتظار بينما يتم مشاركة موقعك',
                          textAlign: TextAlign.center,
                          style: TextStyles.cairoRegular10Gray(context).copyWith(
                            fontSize: 14.sp(context),
                            color: const Color(0xFFA0A0A0),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        ),
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
    for (var i = 1; i <= 5; i++) {
      canvas.drawCircle(center, size.width * 0.12 * i, paint);
    }
  }

  @override
  bool shouldRepaint(_RingsPainter old) => old.color != color;
}