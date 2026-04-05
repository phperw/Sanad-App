import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sanad/core/helper/responsive_extensions.dart';
import 'package:sanad/core/helper/spacing.dart';
import 'package:sanad/core/theme/text_styles.dart';
import 'package:sanad/features/campaign/model/campaign_mode.dart';
import 'widgets/attendance_details_card_widget.dart';
import 'widgets/confirmation_actions_widget.dart';
import 'widgets/current_location_card_widget.dart';
class AttendanceConfirmationScreen extends StatefulWidget {
  final double taskLatitude;
  final double taskLongitude;
  final double radiusMeters;
  final Campaign camp;

  const AttendanceConfirmationScreen({
    super.key,
    required this.taskLatitude,
    required this.taskLongitude,
    required this.camp,
    required this.radiusMeters,
  });

  @override
  State<AttendanceConfirmationScreen> createState() =>
      _AttendanceConfirmationScreenState();
}

class _AttendanceConfirmationScreenState
    extends State<AttendanceConfirmationScreen> {
  Position? _currentPosition;
  bool _isLoading = true;
  double? _distanceMeters;
  bool _isWithinRange = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        await Geolocator.openLocationSettings();
        setState(() => _isLoading = false);
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() => _isLoading = false);
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        await Geolocator.openAppSettings();
        setState(() => _isLoading = false);
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final distance = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        widget.taskLatitude,
        widget.taskLongitude,
      );

      setState(() {
        _currentPosition = position;
        _distanceMeters = distance;
        _isWithinRange = distance <= widget.radiusMeters;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'تأكيد الحضور',
          style: TextStyles.cairoBold32Dark(context)
              .copyWith(fontSize: 18.sp(context), color: onSurface),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: onSurface, size: 20.r(context)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: context.responsivePadding(horizontal: 20, top: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('موقعك الحالي',
                      style: TextStyles.cairoRegular14Muted(context)),
                  verticalSpace(context, height: 12),

                  // ← بعت البيانات للـ widget
                  CurrentLocationCardWidget(
                    currentPosition: _currentPosition,
                    isWithinRange: _isWithinRange,
                    distanceMeters: _distanceMeters,
                    taskLatitude: widget.taskLatitude,
                    taskLongitude: widget.taskLongitude,
                    radiusMeters: widget.radiusMeters,
                  ),

                  verticalSpace(context, height: 24),
                  Text('تفاصيل تسجيل الحضور',
                      style: TextStyles.cairoRegular14Muted(context)),
                  verticalSpace(context, height: 12),
                   AttendanceDetailsCardWidget(camp: widget.camp),
                  verticalSpace(context, height: 20),
                ],
              ),
            ),
      bottomNavigationBar: ConfirmationActionsWidget(
      ),
    );
  }
}
