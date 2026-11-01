import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sanad/core/networking/api_result.dart';
import '../../data/models/OSO/sos_request_model.dart';
import '../../data/repo/OSO/sos_repository.dart';
part 'sos_state.dart';

class SosLocationException implements Exception {
  final String message;
  const SosLocationException(this.message);
}

class SosCubit extends Cubit<SosState> {
  final SosRepository _sosRepository;

  SosCubit(this._sosRepository) : super(SosInitial());

  static const Duration _pollInterval = Duration(seconds: 5);
  static const Duration _locationInterval = Duration(seconds: 15);

  Timer? _pollTimer;
  Timer? _locationTimer;
  int? _requestId;
  SosRequestModel? _lastRequest;
  bool _polling = false;
  bool _pushingLocation = false;

  SosRequestModel? get lastRequest => _lastRequest;

  Future<void> sendSos() async {
    emit(SosSendLoading());
    try {
      final position = await _determinePosition(
        timeLimit: const Duration(seconds: 15),
      );
      final result = await _sosRepository.sendSos(
        latitude: position.latitude,
        longitude: position.longitude,
      );
      if (isClosed) return;
      switch (result) {
        case Success(:final data):
          _requestId = data.id;
          _lastRequest = data;
          emit(SosSendSuccess(data));
        case Failure(:final error):
          emit(SosSendError(error.message));
      }
    } on SosLocationException catch (e) {
      if (!isClosed) emit(SosSendError(e.message));
    } catch (_) {
      if (!isClosed) emit(SosSendError('حدث خطأ غير متوقع، حاول مرة أخرى'));
    }
  }

  Future<void> startTracking() async {
    _startTimers();
    await _poll();
  }

  Future<void> cancelSos() async {
    _stopTimers();
    emit(SosCancelLoading());
    final result = await _sosRepository.cancel();
    if (isClosed) return;
    switch (result) {
      case Success():
        emit(SosCancelSuccess());
      case Failure(:final error):
        emit(SosCancelError(error.message));
        _startTimers();
    }
  }

  void _startTimers() {
    _stopTimers();
    _pollTimer = Timer.periodic(_pollInterval, (_) => _poll());
    _locationTimer = Timer.periodic(_locationInterval, (_) => _pushLocation());
  }

  void _stopTimers() {
    _pollTimer?.cancel();
    _locationTimer?.cancel();
    _pollTimer = null;
    _locationTimer = null;
  }

  Future<void> _poll() async {
    if (_polling || isClosed) return;
    _polling = true;
    try {
      final id = _requestId;
      if (id == null) {
        final result = await _sosRepository.getActive();
        if (isClosed) return;
        switch (result) {
          case Success(:final data):
            if (data == null) {
              _stopTimers();
              emit(SosNoActive());
              return;
            }
            _requestId = data.id;
            _lastRequest = data;
            emit(SosTracking(data));
          case Failure():
            return;
        }
        return;
      }

      final result = await _sosRepository.getById(id);
      if (isClosed) return;
      switch (result) {
        case Success(:final data):
          _lastRequest = data;
          if (data.isActive) {
            emit(SosTracking(data));
          } else {
            _stopTimers();
            emit(SosTrackingEnded(data));
          }
        case Failure():
          return;
      }
    } finally {
      _polling = false;
    }
  }

  Future<void> _pushLocation() async {
    final id = _requestId;
    if (id == null || _pushingLocation || isClosed) return;
    _pushingLocation = true;
    try {
      final position = await _determinePosition(
        timeLimit: const Duration(seconds: 8),
      );
      await _sosRepository.updateLocation(
        id: id,
        latitude: position.latitude,
        longitude: position.longitude,
      );
    } catch (_) {
    } finally {
      _pushingLocation = false;
    }
  }

  Future<Position> _determinePosition({required Duration timeLimit}) async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw const SosLocationException(
        'الموقع الجغرافي معطل، فعّله وحاول مرة أخرى',
      );
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied) {
      throw const SosLocationException('تم رفض صلاحية الموقع');
    }
    if (permission == LocationPermission.deniedForever) {
      throw const SosLocationException(
        'تم رفض صلاحية الموقع بشكل دائم، فعّلها من إعدادات الهاتف',
      );
    }

    try {
      return await Geolocator.getCurrentPosition(
        locationSettings: LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: timeLimit,
        ),
      );
    } on TimeoutException {
      final lastKnown = await Geolocator.getLastKnownPosition();
      if (lastKnown != null) return lastKnown;
      throw const SosLocationException(
        'تعذر تحديد موقعك، تأكد من تشغيل الـ GPS وحاول مرة أخرى',
      );
    } on LocationServiceDisabledException {
      throw const SosLocationException(
        'الموقع الجغرافي معطل، فعّله وحاول مرة أخرى',
      );
    }
  }

  @override
  Future<void> close() {
    _stopTimers();
    return super.close();
  }
}