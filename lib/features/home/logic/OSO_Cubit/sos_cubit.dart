import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sanad/core/networking/api_result.dart';
import '../../data/repo/OSO/sos_repository.dart';
part 'sos_state.dart';

class SosCubit extends Cubit<SosState> {
  final SosRepository _sosRepository;

  SosCubit(this._sosRepository) : super(SosInitial());

  Future<void> sendSos() async {
    emit(SosSendLoading());
    try {
      final position = await _determinePosition();
      final result = await _sosRepository.sendSos(
        latitude: position.latitude,
        longitude: position.longitude,
      );
      switch (result) {
        case Success():
          emit(SosSendSuccess());
        case Failure(:final error):
          emit(SosSendError(error.message));
      }
    } catch (e) {
      emit(SosSendError(e.toString()));
    }
  }

  Future<void> cancelSos() async {
    emit(SosCancelLoading());
    final result = await _sosRepository.cancelSos();
    switch (result) {
      case Success():
        emit(SosCancelSuccess());
      case Failure(:final error):
        emit(SosCancelError(error.message));
    }
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) throw Exception('الموقع الجغرافي معطل');

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('تم رفض صلاحية الموقع');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      throw Exception('تم رفض صلاحية الموقع بشكل دائم');
    }

    return await Geolocator.getCurrentPosition();
  }
}