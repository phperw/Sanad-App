import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sanad/core/constants/app_images.dart';
import 'package:sanad/core/helper/responsive_extensions.dart';
import 'package:sanad/core/helper/spacing.dart';
import 'package:sanad/core/routing/router.dart';
import '../../../core/helper/shared_pref_helper.dart';
import '../../../core/helper/shared_pref_keys.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _controller.forward();

    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        String? token = SharedPrefHelper.getData(
          key: SharedPrefKeys.accessToken,
        );

        if (token != null && token.isNotEmpty) {
          context.go(AppRouter.khome);
        } else {
          context.go(AppRouter.konboarding);
        }
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
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    Assets.logoSplash,
                    width: 220.w(context),
                    height: 220.w(context),
                  ),
                  verticalSpace(context, height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
