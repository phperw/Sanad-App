import 'dart:async';

import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

abstract interface class NearbyMissionsLocationProvider {
  Future<LatLng> currentPosition();
}

class NearbyMissionsLocationException implements Exception {
  final String message;

  const NearbyMissionsLocationException(this.message);

  @override
  String toString() => message;
}

class GeolocatorNearbyMissionsLocationProvider
    implements NearbyMissionsLocationProvider {
  const GeolocatorNearbyMissionsLocationProvider();

  @override
  Future<LatLng> currentPosition() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        throw const NearbyMissionsLocationException(
          'خدمة الموقع معطلة. فعّلها ثم حاول مرة أخرى.',
        );
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever) {
        throw const NearbyMissionsLocationException(
          'تم رفض إذن الموقع نهائيًا. فعّله من إعدادات التطبيق.',
        );
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.unableToDetermine) {
        throw const NearbyMissionsLocationException(
          'يلزم السماح بإذن الموقع لعرض المهام القريبة.',
        );
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      ).timeout(const Duration(seconds: 20));
      return LatLng(position.latitude, position.longitude);
    } on NearbyMissionsLocationException {
      rethrow;
    } on TimeoutException {
      throw const NearbyMissionsLocationException(
        'تعذر تحديد موقعك. تحقق من تشغيل GPS وحاول مرة أخرى.',
      );
    } on LocationServiceDisabledException {
      throw const NearbyMissionsLocationException(
        'خدمة الموقع معطلة. فعّلها ثم حاول مرة أخرى.',
      );
    }
  }
}
