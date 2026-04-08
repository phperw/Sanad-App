import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:sanad/core/networking/dio_factory.dart';
import 'package:sanad/features/emergency/data/sos_service.dart';

class EmergencyScreen extends StatefulWidget {
  const EmergencyScreen({super.key});

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  // ── State ──────────────────────────────────────────
  Position? _currentPosition;
  bool _isSharing = false;
  bool _isSending = false;
  StreamSubscription<Position>? _locationSubscription;
  final MapController _mapController = MapController();
  final List<LatLng> _routePoints = []; // نقاط المسار
  final SosService _sosService = SosService(DioFactory.getDio());

  // ── Location ───────────────────────────────────────
  Future<bool> _checkPermission() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return false;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return false;
    }
    if (permission == LocationPermission.deniedForever) {
      await Geolocator.openAppSettings();
      return false;
    }
    return true;
  }

  Future<void> _startLiveTracking() async {
    final hasPermission = await _checkPermission();
    if (!hasPermission) return;

    setState(() => _isSharing = true);

    // جيب الموقع الحالي فوراً وابعته
    final firstPosition = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    _onNewPosition(firstPosition);

    // ابدأ الـ stream
    _locationSubscription = Geolocator.getPositionStream(
      locationSettings: const LocationSettings(
        accuracy: LocationAccuracy.high,
        distanceFilter: 10, // كل 10 متر
      ),
    ).listen(_onNewPosition);
  }

  void _onNewPosition(Position position) async {
    final newPoint = LatLng(position.latitude, position.longitude);

    setState(() {
      _currentPosition = position;
      _routePoints.add(newPoint); // أضف للمسار
    });

    // حرّك الخريطة مع المستخدم
    _mapController.move(newPoint, 16);

    // ابعت للـ API
    await _sendSos(position);

    debugPrint('📍 LAT: ${position.latitude}, LNG: ${position.longitude}');
  }

  Future<void> _sendSos(Position position) async {
    try {
      setState(() => _isSending = true);
      await _sosService.sendSosRequest(
        latitude: position.latitude,
        longitude: position.longitude,
      );
      debugPrint('✅ SOS sent');
    } catch (e) {
      debugPrint('❌ SOS failed: $e');
    } finally {
      setState(() => _isSending = false);
    }
  }

  void _stopLiveTracking() {
    _locationSubscription?.cancel();
    setState(() {
      _isSharing = false;
      _currentPosition = null;
      _routePoints.clear();
    });
  }

  @override
  void initState() {
    super.initState();
    _startLiveTracking(); // يبدأ تلقائياً لما الشاشة تفتح
  }

  @override
  void dispose() {
    _locationSubscription?.cancel();
    super.dispose();
  }

  // ── UI ─────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // ── Header أحمر ──
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(16, 60, 16, 20),
            color: Colors.red,
            child: const Column(
              children: [
                Text(
                  'طلب الطوارئ نشط',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'تم إبلاغ الإدارة — المساعدة في الطريق',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  const SizedBox(height: 8),

                  // ── كارد الخريطة + الـ Tracking ──
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade200),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    clipBehavior: Clip.hardEdge,
                    child: Column(
                      children: [
                        // الخريطة
                        SizedBox(
                          height: 220,
                          child: _currentPosition == null
                              ? const Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      CircularProgressIndicator(
                                        color: Colors.red,
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        'جاري تحديد موقعك...',
                                        style: TextStyle(color: Colors.grey),
                                      ),
                                    ],
                                  ),
                                )
                              : FlutterMap(
                                  mapController: _mapController,
                                  options: MapOptions(
                                    initialCenter: LatLng(
                                      _currentPosition!.latitude,
                                      _currentPosition!.longitude,
                                    ),
                                    initialZoom: 16,
                                  ),
                                  children: [
                                    // طبقة الخريطة Satellite
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

                                    // خط المسار
                                    if (_routePoints.length > 1)
                                      PolylineLayer(
                                        polylines: [
                                          Polyline(
                                            points: _routePoints,
                                            strokeWidth: 4,
                                            color: Colors.red,
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
                                          width: 50,
                                          height: 50,
                                          child: Stack(
                                            alignment: Alignment.center,
                                            children: [
                                              // دايرة نابضة
                                              Container(
                                                width: 50,
                                                height: 50,
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.red.withOpacity(
                                                    0.3,
                                                  ),
                                                ),
                                              ),
                                              // نقطة المركز
                                              Container(
                                                width: 20,
                                                height: 20,
                                                decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                        ),

                        // معلومات الموقع تحت الخريطة
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: const BoxDecoration(
                                  color: Color(0xFFE8F5E9),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.location_on,
                                  color: Colors.green,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        const Text(
                                          'موقعك يُشارك الآن',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            fontFamily: 'Cairo',
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        // Badge
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: _isSharing
                                                ? Colors.green
                                                : Colors.grey,
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              if (_isSending)
                                                const SizedBox(
                                                  width: 8,
                                                  height: 8,
                                                  child:
                                                      CircularProgressIndicator(
                                                        color: Colors.white,
                                                        strokeWidth: 1.5,
                                                      ),
                                                ),
                                              if (_isSending)
                                                const SizedBox(width: 4),
                                              Text(
                                                _isSharing ? 'نشط' : 'متوقف',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 11,
                                                  fontFamily: 'Cairo',
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _currentPosition != null
                                          ? 'الإدارة تتابع موقعك في الوقت الفعلي'
                                          : 'جاري تحديد موقعك...',
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                      ),
                                      textAlign: TextAlign.right,
                                    ),
                                    // عدد النقاط المرسلة
                                    if (_routePoints.isNotEmpty)
                                      Text(
                                        'تم إرسال ${_routePoints.length} تحديث للموقع',
                                        style: const TextStyle(
                                          color: Colors.green,
                                          fontSize: 11,
                                          fontFamily: 'Cairo',
                                        ),
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

                  const SizedBox(height: 12),

                  // ── كارد تم إبلاغ الإدارة ──
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade200),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.notifications_outlined, color: Colors.grey),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'تم إبلاغ الإدارة',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  fontFamily: 'Cairo',
                                ),
                              ),
                              Text(
                                'وتم إشعار المتطوعين القريبين منك',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  // ── كارد الاتصال ──
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade200),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: const BoxDecoration(
                            color: Color(0xFFE8F5E9),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.phone,
                            color: Colors.green,
                            size: 32,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'تواصل مباشر مع الإدارة',
                          style: TextStyle(fontSize: 14, fontFamily: 'Cairo'),
                        ),
                        const Text(
                          '16878',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Cairo',
                          ),
                        ),
                        const Text(
                          'اضغط للاتصال',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // ── زرار إلغاء الطوارئ ──
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: OutlinedButton(
                      onPressed: () {
                        _stopLiveTracking();
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.green),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'أنا بخير — إلغاء الطوارئ',
                        style: TextStyle(
                          color: Colors.green,
                          fontSize: 16,
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'سيتم إيقاف مشاركة موقعك',
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
