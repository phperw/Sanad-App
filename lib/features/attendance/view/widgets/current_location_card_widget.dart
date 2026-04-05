import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:sanad/core/helper/responsive_extensions.dart';
import 'package:sanad/core/helper/spacing.dart';
import 'package:sanad/core/theme/app_colors.dart';
import 'package:sanad/core/theme/text_styles.dart';
import '../../../../core/constants/app_images.dart';
class CurrentLocationCardWidget extends StatelessWidget {
  final Position? currentPosition;
  final bool isWithinRange;
  final double? distanceMeters;
  final double taskLatitude;
  final double taskLongitude;
  final double radiusMeters;

  const CurrentLocationCardWidget({
    super.key,
    required this.currentPosition,
    required this.isWithinRange,
    required this.distanceMeters,
    required this.taskLatitude,
    required this.taskLongitude,
    required this.radiusMeters,
  });

  String _formatDistance(double meters) {
    if (meters < 1000) return 'على بعد ${meters.toInt()} متر';
    return 'على بعد ${(meters / 1000).toStringAsFixed(1)} كم';
  }

  @override
  Widget build(BuildContext context) {
    final cardColor = Theme.of(context).cardColor;
    final dividerColor = Theme.of(context).dividerColor;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Container(
      decoration: BoxDecoration(
        color: cardColor,
        border: Border.all(color: dividerColor),
        borderRadius: BorderRadius.circular(16.r(context)),
      ),
      child: Column(
        children: [
          // الخريطة بدل الـ Image.asset
          ClipRRect(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(16.r(context)),
            ),
            child: SizedBox(
              height: 120.h(context),
              child: currentPosition == null
                  ? const Center(child: Text('تعذر تحديد الموقع'))
                  : FlutterMap(
                      options: MapOptions(
                        initialCenter: LatLng(
                          currentPosition!.latitude,
                          currentPosition!.longitude,
                        ),
                        initialZoom: 16,
                        interactionOptions: const InteractionOptions(
                          flags: InteractiveFlag.none,
                        ),
                      ),
                      children: [
                        TileLayer(
                          urlTemplate:
                              'https://server.arcgisonline.com/ArcGIS/rest/services/World_Imagery/MapServer/tile/{z}/{y}/{x}',
                          userAgentPackageName: 'com.example.sanad',
                        ),
                        Opacity(
                          opacity: 0.4,
                          child: TileLayer(
                            urlTemplate:
                                'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                            userAgentPackageName: 'com.example.sanad',
                          ),
                        ),
                        // دايرة النطاق
                        CircleLayer(
                          circles: [
                            CircleMarker(
                              point: LatLng(taskLatitude, taskLongitude),
                              radius: radiusMeters,
                              color: AppColors.primaryColor.withOpacity(0.15),
                              borderColor: AppColors.primaryColor,
                              borderStrokeWidth: 2,
                              useRadiusInMeter: true,
                            ),
                          ],
                        ),
                        // موقع المستخدم
                        MarkerLayer(
                          markers: [
                            Marker(
                              point: LatLng(
                                currentPosition!.latitude,
                                currentPosition!.longitude,
                              ),
                              width: 36,
                              height: 36,
                              child: Icon(
                                Icons.location_pin,
                                color: Colors.red,
                                size: 36.r(context),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
            ),
          ),

          // معلومات الموقع - نفس الـ UI بتاعك
          Padding(
            padding: context.responsivePadding(all: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'موقعك الحالي',
                      style: TextStyles.cairoBold32Dark(context)
                          .copyWith(fontSize: 14.sp(context), color: onSurface),
                    ),
                    verticalSpace(context, height: 4),
                    Row(
                      children: [
                        Icon(
                          isWithinRange
                              ? Icons.check_circle_outline
                              : Icons.cancel_outlined,
                          color: isWithinRange
                              ? AppColors.primaryColor
                              : Colors.orange,
                          size: 16.r(context),
                        ),
                        horizontalSpace(context, width: 4),
                        Text(
                          distanceMeters != null
                              ? '${isWithinRange ? "أنت داخل النطاق" : "أنت خارج النطاق"} — ${_formatDistance(distanceMeters!)}'
                              : 'جاري تحديد الموقع...',
                          style: TextStyles.cairoRegular14Muted(context)
                              .copyWith(
                            fontSize: 12.sp(context),
                            color: isWithinRange
                                ? AppColors.primaryColor
                                : Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: context.responsivePadding(all: 8),
                  decoration: BoxDecoration(
                    color: isWithinRange
                        ? AppColors.lightGreenishWhite
                        : Colors.orange.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.location_on_outlined,
                    color: isWithinRange
                        ? AppColors.primaryColor
                        : Colors.orange,
                    size: 20.r(context),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
// class CurrentLocationCardWidget extends StatelessWidget {
//   const CurrentLocationCardWidget({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final cardColor = Theme.of(context).cardColor;
//     final dividerColor = Theme.of(context).dividerColor;
//     final onSurface = Theme.of(context).colorScheme.onSurface;

//     return Container(
//       decoration: BoxDecoration(
//         color: cardColor,
//         border: Border.all(color: dividerColor),
//         borderRadius: BorderRadius.circular(16.r(context)),
//       ),
//       child: Column(
//         children: [
//           ClipRRect(
//             borderRadius: BorderRadius.vertical(
//               top: Radius.circular(16.r(context)),
//             ),
//             child: Image.asset(
//               Assets.mapTest,
//               height: 120.h(context),
//               width: double.infinity,
//               fit: BoxFit.cover,
//             ),
//           ),
//           Padding(
//             padding: context.responsivePadding(all: 16),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       'موقعك الحالي',
//                       style: TextStyles.cairoBold32Dark(
//                         context,
//                       ).copyWith(fontSize: 14.sp(context), color: onSurface),
//                     ),
//                     verticalSpace(context, height: 4),
//                     Row(
//                       children: [
//                         Icon(
//                           Icons.check_circle_outline,
//                           color: AppColors.primaryColor,
//                           size: 16.r(context),
//                         ),
//                         horizontalSpace(context, width: 4),
//                         Text(
//                           'أنت داخل النطاق — على بعد 50 متر',
//                           style: TextStyles.cairoRegular14Muted(context)
//                               .copyWith(
//                                 fontSize: 12.sp(context),
//                                 color: AppColors.primaryColor,
//                               ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//                 Container(
//                   padding: context.responsivePadding(all: 8),
//                   decoration: const BoxDecoration(
//                     color: AppColors.lightGreenishWhite,
//                     shape: BoxShape.circle,
//                   ),
//                   child: Icon(
//                     Icons.location_on_outlined,
//                     color: AppColors.primaryColor,
//                     size: 20.r(context),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
