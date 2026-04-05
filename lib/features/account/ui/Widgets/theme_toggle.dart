import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_images.dart';
import '../../../../core/helper/responsive_extensions.dart';
import '../../logic/theme_cubit.dart';

class ThemeToggle extends StatelessWidget {
  const ThemeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, bool>(
      builder: (context, isDark) {
        return GestureDetector(
          onTap: () => context.read<ThemeCubit>().toggleTheme(),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            width: 65.w(context),
            height: 32.h(context),
            clipBehavior: Clip.antiAlias,
            decoration: ShapeDecoration(
              color: isDark ? ThemeCubit.darkNavBg : const Color(0xFFF0F0F0),
              shape: RoundedRectangleBorder(
                side: isDark
                    ? BorderSide(width: 1, color: const Color(0xFF2A2A3E))
                    : BorderSide(
                        width: 1.w(context),
                        color: Colors.grey.shade300,
                      ),
                borderRadius: BorderRadius.circular(24.r(context)),
              ),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                AnimatedAlign(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  alignment: isDark
                      ? Alignment.centerLeft
                      : Alignment.centerRight,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 3.w(context)),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: 26.w(context),
                      height: 26.w(context),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isDark ? const Color(0xFF2A2A3E) : Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.all(5.w(context)),
                        child: Image.asset(
                          isDark ? Assets.moon : Assets.sun,
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
