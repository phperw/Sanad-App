import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanad/core/networking/api_result.dart';
import '../data/mission_repository.dart';
import '../data/models/mission_details.dart';

class MissionDetailsState {
  final MissionDetails? mission;
  final bool isLoading;
  final bool isCheckingIn;
  final bool isSubmitting;
  final bool reportSubmitted;
  final String? errorMessage;
  final String? successMessage;

  const MissionDetailsState({
    this.mission,
    this.isLoading = false,
    this.isCheckingIn = false,
    this.isSubmitting = false,
    this.reportSubmitted = false,
    this.errorMessage,
    this.successMessage,
  });

  MissionDetailsState copyWith({
    MissionDetails? mission,
    bool? isLoading,
    bool? isCheckingIn,
    bool? isSubmitting,
    bool? reportSubmitted,
    String? errorMessage,
    String? successMessage,
    bool clearError = false,
    bool clearSuccess = false,
  }) {
    return MissionDetailsState(
      mission: mission ?? this.mission,
      isLoading: isLoading ?? this.isLoading,
      isCheckingIn: isCheckingIn ?? this.isCheckingIn,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      reportSubmitted: reportSubmitted ?? this.reportSubmitted,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      successMessage: clearSuccess
          ? null
          : successMessage ?? this.successMessage,
    );
  }
}

class MissionCubit extends Cubit<MissionDetailsState> {
  final MissionRepository _repository;

  MissionCubit(this._repository) : super(const MissionDetailsState());

  Future<void> loadMission(int missionId) async {
    emit(state.copyWith(isLoading: true, clearError: true, clearSuccess: true));
    final result = await _repository.getMissionDetails(missionId);
    if (isClosed) return;
    switch (result) {
      case Success(:final data):
        emit(state.copyWith(mission: data, isLoading: false));
      case Failure(:final error):
        emit(
          state.copyWith(
            isLoading: false,
            errorMessage: error.message,
            clearSuccess: true,
          ),
        );
    }
  }

  Future<void> checkIn({
    required int missionId,
    required double latitude,
    required double longitude,
  }) async {
    emit(
      state.copyWith(isCheckingIn: true, clearError: true, clearSuccess: true),
    );
    final result = await _repository.checkIn(
      missionId: missionId,
      latitude: latitude,
      longitude: longitude,
    );
    if (isClosed) return;
    switch (result) {
      case Success():
        final refreshed = await _repository.getMissionDetails(missionId);
        if (isClosed) return;
        switch (refreshed) {
          case Success(:final data):
            emit(
              state.copyWith(
                mission: data,
                isCheckingIn: false,
                successMessage: 'تم تسجيل حضورك في المهمة',
                clearError: true,
              ),
            );
          case Failure(:final error):
            emit(
              state.copyWith(
                isCheckingIn: false,
                errorMessage:
                    'تم تسجيل الحضور لكن تعذر تحديث تفاصيل المهمة: ${error.message}',
                clearSuccess: true,
              ),
            );
        }
      case Failure(:final error):
        emit(
          state.copyWith(
            isCheckingIn: false,
            errorMessage: error.message,
            clearSuccess: true,
          ),
        );
    }
  }

  Future<void> submitReport({
    required int missionId,
    required String notes,
    required List<String> imageDataUris,
    required int rating,
  }) async {
    emit(
      state.copyWith(isSubmitting: true, clearError: true, clearSuccess: true),
    );

    final uploadedImages = <String>[];
    for (final imageDataUri in imageDataUris) {
      final uploadResult = await _repository.uploadMissionImage(imageDataUri);
      if (isClosed) return;
      switch (uploadResult) {
        case Success(:final data):
          uploadedImages.add(data);
        case Failure(:final error):
          emit(
            state.copyWith(
              isSubmitting: false,
              errorMessage: error.message,
              clearSuccess: true,
            ),
          );
          return;
      }
    }

    final result = await _repository.submitMissionReport(
      missionId: missionId,
      notes: notes,
      images: uploadedImages,
      rating: rating,
    );
    if (isClosed) return;
    switch (result) {
      case Success():
        final refreshed = await _repository.getMissionDetails(missionId);
        if (isClosed) return;
        switch (refreshed) {
          case Success(:final data):
            emit(
              state.copyWith(
                mission: data,
                isSubmitting: false,
                reportSubmitted: true,
                successMessage: 'تم إرسال تقرير المهمة بنجاح',
                clearError: true,
              ),
            );
          case Failure():
            emit(
              state.copyWith(
                isSubmitting: false,
                reportSubmitted: true,
                errorMessage:
                    'تم إرسال التقرير بنجاح لكن تعذر تحديث تفاصيل المهمة',
                clearSuccess: true,
              ),
            );
        }
      case Failure(:final error):
        emit(
          state.copyWith(
            isSubmitting: false,
            errorMessage: error.message,
            clearSuccess: true,
          ),
        );
    }
  }
}
