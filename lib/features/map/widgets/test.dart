// lib/screens/attendance_confirmation_screen.dart

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class AttendanceConfirmationScreen extends StatefulWidget {
  final double taskLatitude; // موقع المهمة من الـ API
  final double taskLongitude;
  final double radiusMeters; // attendance.radiusMeters من الـ API

  const AttendanceConfirmationScreen({
    super.key,
    required this.taskLatitude,
    required this.taskLongitude,
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
      // 1. تأكد إن الـ GPS شغال
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // اطلب من المستخدم يفتح الـ GPS
        await Geolocator.openLocationSettings();
        setState(() => _isLoading = false);
        return;
      }

      // 2. تحقق من الـ Permission
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        // اطلب الإذن
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() => _isLoading = false);
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // المستخدم رفض بشكل دائم → افتحله الإعدادات
        await Geolocator.openAppSettings();
        setState(() => _isLoading = false);
        return;
      }

      // 3. جيب الموقع
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      print('LAT: ${position.latitude}, LNG: ${position.longitude}');

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
      debugPrint('Location error: $e');
    }
  }

  String _formatDistance(double meters) {
    if (meters < 1000) {
      return 'على بعد ${meters.toInt()} متر';
    } else {
      return 'على بعد ${(meters / 1000).toStringAsFixed(1)} كم';
    }
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final days = [
      'الأحد',
      'الإثنين',
      'الثلاثاء',
      'الأربعاء',
      'الخميس',
      'الجمعة',
      'السبت',
    ];
    final months = [
      'يناير',
      'فبراير',
      'مارس',
      'أبريل',
      'مايو',
      'يونيو',
      'يوليو',
      'أغسطس',
      'سبتمبر',
      'أكتوبر',
      'نوفمبر',
      'ديسمبر',
    ];

    final dateStr =
        '${days[now.weekday % 7]}، ${now.day} ${months[now.month - 1]} ${now.year}';
    final timeStr =
        '${now.hour > 12 ? now.hour - 12 : now.hour}:${now.minute.toString().padLeft(2, '0')} ${now.hour >= 12 ? 'PM' : 'AM'}';

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A2E),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A1A2E),
        elevation: 0,
        title: const Text(
          'تأكيد الحضور',
          style: TextStyle(color: Colors.white),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // عنوان "موقعك الحالي"
                  const Text(
                    'موقعك الحالي',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 12),

                  // كارد الخريطة
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: const Color(0xFF2A2A3E),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Column(
                      children: [
                        // الخريطة
                        SizedBox(
                          height: 200,
                          child: _currentPosition == null
                              ? const Center(
                                  child: Text(
                                    'تعذر تحديد الموقع',
                                    style: TextStyle(color: Colors.white70),
                                  ),
                                )
                              : FlutterMap(
                                  options: MapOptions(
                                    initialCenter: LatLng(
                                      _currentPosition!.latitude,
                                      _currentPosition!.longitude,
                                    ),
                                    initialZoom: 16,
                                    interactionOptions:
                                        const InteractionOptions(
                                          flags: InteractiveFlag
                                              .none, // الخريطة ثابتة
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
                                        userAgentPackageName:
                                            'com.example.sanad',
                                      ),
                                    ),
                                    // TileLayer(
                                    //   urlTemplate:
                                    //       'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                    //   userAgentPackageName:
                                    //       'com.example.yourapp',
                                    // ),
                                    // دايرة نطاق الحضور
                                    CircleLayer(
                                      circles: [
                                        CircleMarker(
                                          point: LatLng(
                                            widget.taskLatitude,
                                            widget.taskLongitude,
                                          ),
                                          radius: widget.radiusMeters,
                                          color: Colors.green.withOpacity(0.2),
                                          borderColor: Colors.green,
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
                                            _currentPosition!.latitude,
                                            _currentPosition!.longitude,
                                          ),
                                          width: 40,
                                          height: 40,
                                          child: const Icon(
                                            Icons.location_pin,
                                            color: Colors.red,
                                            size: 40,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                        ),

                        // معلومات الموقع
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              // أيقونة الموقع
                              Container(
                                width: 44,
                                height: 44,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withOpacity(0.1),
                                ),
                                child: Icon(
                                  Icons.location_on_outlined,
                                  color: _isWithinRange
                                      ? Colors.green
                                      : Colors.orange,
                                ),
                              ),
                              const SizedBox(width: 12),

                              // النص
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    const Text(
                                      'موقعك الحالي',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          _distanceMeters != null
                                              ? _formatDistance(
                                                  _distanceMeters!,
                                                )
                                              : '',
                                          style: TextStyle(
                                            color: _isWithinRange
                                                ? Colors.green
                                                : Colors.orange,
                                            fontSize: 13,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          _isWithinRange
                                              ? 'أنت داخل النطاق —'
                                              : 'أنت خارج النطاق —',
                                          style: TextStyle(
                                            color: _isWithinRange
                                                ? Colors.green
                                                : Colors.orange,
                                            fontSize: 13,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Icon(
                                          _isWithinRange
                                              ? Icons.check_circle
                                              : Icons.cancel,
                                          color: _isWithinRange
                                              ? Colors.green
                                              : Colors.orange,
                                          size: 16,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // تفاصيل تسجيل الحضور
                  const Text(
                    'تفاصيل تسجيل الحضور',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 12),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: const Color(0xFF2A2A3E),
                    ),
                    child: Column(
                      children: [
                        _detailRow(Icons.calendar_today, dateStr),
                        const Divider(color: Colors.white12),
                        _detailRow(
                          Icons.access_time,
                          timeStr,
                          color: Colors.green,
                        ),
                        const Divider(color: Colors.white12),
                        _detailRow(
                          Icons.info_outline,
                          'سيتم تسجيل وقت وموقع حضورك بشكل فعلي',
                          color: Colors.white38,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),

      // أزرار التأكيد والإلغاء
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _isWithinRange ? _confirmAttendance : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  disabledBackgroundColor: Colors.green.withOpacity(0.4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: const Text(
                  'تأكيد الحضور',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'إلغاء',
                style: TextStyle(color: Colors.white54, fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String text, {Color? color}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            text,
            style: TextStyle(color: color ?? Colors.white, fontSize: 14),
          ),
          const SizedBox(width: 12),
          Icon(icon, color: color ?? Colors.white54, size: 20),
        ],
      ),
    );
  }

  void _confirmAttendance() {
    // هنا بتبعت الـ API request لتسجيل الحضور
    // مثال:
    // attendanceService.checkIn(
    //   latitude: _currentPosition!.latitude,
    //   longitude: _currentPosition!.longitude,
    // );
    Navigator.pop(context);
  }
}
