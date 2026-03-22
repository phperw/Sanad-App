import 'package:flutter/material.dart';
import 'package:sanad/core/helper/responsive_extensions.dart';
import 'package:sanad/core/theme/app_colors.dart';

class MapMissionCard extends StatelessWidget {
  final String title;
  final String distance;
  final bool isActive;
  final VoidCallback onTap;

  const MapMissionCard({
    super.key,
    required this.title,
    required this.distance,
    required this.isActive,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // We use Directionality to ensure Arabic RTL layout
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        padding: context.responsivePadding(all: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r(context)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 1. Right Side: Text Information (Expanded to take available space)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 14.sp(context),
                      fontWeight: FontWeight.bold,
                      color: AppColors.black,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 14.r(context),
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'على بعد $distance',
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: 12.sp(context),
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // 2. Left Side: Action Button
            SizedBox(
              width: 110.w(context),
              height: 38.h(context),
              child: ElevatedButton(
                onPressed: isActive ? onTap : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: isActive
                      ? const Color(0xFF1B8E58)
                      : Colors.grey[200],
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r(context)),
                  ),
                ),
                child: Text(
                  'تسجيل الحضور',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 11.sp(context),
                    fontWeight: FontWeight.bold,
                    color: isActive ? Colors.white : Colors.grey,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
