import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sanad/core/routing/router.dart';
import 'package:sanad/core/theme/app_colors.dart';
import 'package:sanad/core/theme/text_styles.dart';
import 'package:sanad/core/widgets/loading_app.dart';

import '../../logic/register_cubit.dart';
import '../../logic/register_state.dart';

class RegisterCubitListener extends StatelessWidget {
  final Widget child;

  const RegisterCubitListener({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterCubit, RegisterState>(
      listener: (context, state) {
        switch (state) {
          case RegisterLoading():
            showLoadingDialog(context, message: 'جاري إنشاء الحساب');

          case RegisterSuccess(:final data):
            Navigator.of(context, rootNavigator: true).pop();
            _showSuccessCard(context, data.user.fullName);
            Future.delayed(const Duration(milliseconds: 1800), () {
              // CHANGED: Route to login instead of home
              if (context.mounted) context.go(AppRouter.klogin);
            });

          case RegisterFailure(:final error):
            Navigator.of(context, rootNavigator: true).pop();
            _showErrorCard(context, error.message);

          case RegisterInitial():
            break;
        }
      },
      child: child,
    );
  }
}

void _showSuccessCard(BuildContext context, String fullName) {
  final overlay = Overlay.of(context);
  late OverlayEntry entry;

  entry = OverlayEntry(
    builder: (_) => _ToastCard(
      icon: Icons.check_circle_rounded,
      iconColor: AppColors.primaryColor,
      backgroundColor: AppColors.lightGreenishWhite,
      borderColor: AppColors.primaryColor,
      title: 'تم إنشاء الحساب بنجاح',
      subtitle:
          'أهلاً بك، $fullName\nالرجاء تسجيل الدخول للمتابعة', // Optional: Added a prompt to log in
      onDone: () => entry.remove(),
    ),
  );

  overlay.insert(entry);
}

void _showErrorCard(BuildContext context, String message) {
  final overlay = Overlay.of(context);
  late OverlayEntry entry;

  entry = OverlayEntry(
    builder: (_) => _ToastCard(
      icon: Icons.error_rounded,
      iconColor: AppColors.errorColor,
      backgroundColor: const Color(0xFFFFF0F0),
      borderColor: AppColors.errorColor,
      title: 'فشل إنشاء الحساب',
      subtitle: message,
      onDone: () => entry.remove(),
    ),
  );

  overlay.insert(entry);
}

class _ToastCard extends StatefulWidget {
  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final Color borderColor;
  final String title;
  final String subtitle;
  final VoidCallback onDone;

  const _ToastCard({
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    required this.borderColor,
    required this.title,
    required this.subtitle,
    required this.onDone,
  });

  @override
  State<_ToastCard> createState() => _ToastCardState();
}

class _ToastCardState extends State<_ToastCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _opacity = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
    _slide = Tween<Offset>(
      begin: const Offset(0, -0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();

    Future.delayed(const Duration(milliseconds: 2200), () async {
      if (mounted) {
        await _controller.reverse();
        widget.onDone();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 16,
      left: 16,
      right: 16,
      child: FadeTransition(
        opacity: _opacity,
        child: SlideTransition(
          position: _slide,
          child: Material(
            color: Colors.transparent,
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: widget.backgroundColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: widget.borderColor.withOpacity(0.4),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: widget.borderColor.withOpacity(0.12),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: widget.iconColor.withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        widget.icon,
                        color: widget.iconColor,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            widget.title,
                            style: TextStyles.cairoBold14Black2(
                              context,
                            ).copyWith(color: widget.iconColor),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            widget.subtitle,
                            style: TextStyles.cairoRegular12Gray(context),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
