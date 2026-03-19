import 'package:flutter/material.dart';
import 'package:sanad/core/helper/responsive_extensions.dart';
import 'package:sanad/core/helper/spacing.dart';
import 'package:sanad/core/theme/app_colors.dart';

class CustomBottomNavWidget extends StatelessWidget {
  const CustomBottomNavWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70.h(context),
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(
            context,
            icon: Icons.person_outline,
            label: 'حسابي',
            isActive: false,
          ),
          _buildNavItem(
            context,
            icon: Icons.chat_bubble_outline,
            label: 'محادثاتي',
            isActive: false,
          ),
          _buildNavItem(
            context,
            icon: Icons.map_outlined,
            label: 'الخريطة',
            isActive: true,
          ),
          _buildNavItem(
            context,
            icon: Icons.home_outlined,
            label: 'الرئيسية',
            isActive: false,
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required bool isActive,
  }) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: isActive ? AppColors.primaryColor : AppColors.gray,
          size: 24.r(context),
        ),
        verticalSpace(context, height: 4),
        Text(
          label,
          style: TextStyle(
            color: isActive ? AppColors.primaryColor : AppColors.gray,
            fontSize: 10.sp(context),
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
            fontFamily: 'Cairo',
          ),
        ),
        if (isActive) ...[
          verticalSpace(context, height: 4),
          Container(
            height: 2.h(context),
            width: 20.w(context),
            decoration: BoxDecoration(
              color: AppColors.primaryColor,
              borderRadius: BorderRadius.circular(2.r(context)),
            ),
          ),
        ],
      ],
    );
  }
}
