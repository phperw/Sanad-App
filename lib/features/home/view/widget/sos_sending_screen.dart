import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sanad/core/theme/app_colors.dart';
import 'package:sanad/core/theme/text_styles.dart';
import 'package:sanad/core/helper/responsive_extensions.dart';
import 'package:sanad/core/helper/spacing.dart';
import 'package:sanad/core/networking/dio_factory.dart';
import 'package:sanad/core/routing/router.dart';
import '../../data/repo/OSO/sos_repository.dart';
import '../../logic/OSO_Cubit/sos_cubit.dart';
import 'sos_bloc_listener.dart';

class SosSendingScreen extends StatelessWidget {
  const SosSendingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        final cubit = SosCubit(SosRepository(DioFactory.getDio()));
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
                    if (state is SosSendError) {
                      return _ErrorView(message: state.error, isDark: isDark);
                    }
                    return _LoadingView(isDark: isDark);
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

class _LoadingView extends StatelessWidget {
  final bool isDark;

  const _LoadingView({required this.isDark});

  @override
  Widget build(BuildContext context) {
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
          style: TextStyles.cairoRegular10Gray(
            context,
          ).copyWith(fontSize: 14.sp(context), color: const Color(0xFFA0A0A0)),
        ),
      ],
    );
  }
}

class _ErrorView extends StatelessWidget {
  final String message;
  final bool isDark;

  const _ErrorView({required this.message, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 32.w(context)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 100.w(context),
            height: 100.w(context),
            decoration: BoxDecoration(
              color: AppColors.sosRed.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.location_off_rounded,
              color: AppColors.sosRed,
              size: 44.sp(context),
            ),
          ),
          verticalSpace(context, height: 28),
          Text(
            'تعذر إرسال طلب الطوارئ',
            textAlign: TextAlign.center,
            style: TextStyles.cairoBold20Dark(context).copyWith(
              fontSize: 20.sp(context),
              color: isDark ? Colors.white : AppColors.darkBlue,
            ),
          ),
          verticalSpace(context, height: 8),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyles.cairoRegular10Gray(context).copyWith(
              fontSize: 14.sp(context),
              color: const Color(0xFFA0A0A0),
              height: 1.6,
            ),
          ),
          verticalSpace(context, height: 28),
          GestureDetector(
            onTap: () => context.read<SosCubit>().sendSos(),
            child: Container(
              width: double.infinity,
              height: 52.h(context),
              decoration: BoxDecoration(
                color: AppColors.sosRed,
                borderRadius: BorderRadius.circular(14.r(context)),
              ),
              child: Center(
                child: Text(
                  'إعادة المحاولة',
                  style: TextStyles.cairoBold16White(context),
                ),
              ),
            ),
          ),
          verticalSpace(context, height: 8),
          TextButton(
            onPressed: () => context.go(AppRouter.khome),
            child: Text(
              'رجوع',
              style: TextStyles.cairoBold14Primary(context),
            ),
          ),
        ],
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