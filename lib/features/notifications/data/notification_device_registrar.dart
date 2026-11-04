import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import 'notifications_repository.dart';

class NotificationDeviceRegistrar {
  final NotificationsRepository _repository;
  StreamSubscription<String>? _tokenSubscription;

  NotificationDeviceRegistrar(this._repository);

  Future<void> start() async {
    try {
      final messaging = FirebaseMessaging.instance;
      final settings = await messaging.requestPermission();
      if (settings.authorizationStatus != AuthorizationStatus.authorized &&
          settings.authorizationStatus != AuthorizationStatus.provisional) {
        return;
      }

      final token = await messaging.getToken();
      if (token != null && token.trim().isNotEmpty) {
        await _register(token);
      }

      await _tokenSubscription?.cancel();
      _tokenSubscription = messaging.onTokenRefresh.listen((token) {
        if (token.trim().isNotEmpty) unawaited(_register(token));
      });
    } catch (_) {
      // Push setup is optional; in-app notifications use the API independently.
    }
  }

  Future<void> unregisterCurrentDevice() async {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (token == null || token.trim().isEmpty) return;
      await _repository.unregisterDevice(fcmToken: token);
    } catch (_) {
      // Firebase may be unavailable or unconfigured in this build.
    }
  }

  Future<void> dispose() async {
    await _tokenSubscription?.cancel();
    _tokenSubscription = null;
  }

  Future<void> _register(String token) async {
    try {
      await _repository.registerDevice(
        fcmToken: token,
        platform: _platformName,
      );
    } catch (_) {
      // A token registration failure must not block the notifications API.
    }
  }

  String get _platformName {
    if (kIsWeb) return 'web';
    return switch (defaultTargetPlatform) {
      TargetPlatform.android => 'android',
      TargetPlatform.iOS => 'ios',
      TargetPlatform.macOS => 'macos',
      TargetPlatform.windows => 'windows',
      TargetPlatform.linux => 'linux',
      TargetPlatform.fuchsia => 'fuchsia',
    };
  }
}
