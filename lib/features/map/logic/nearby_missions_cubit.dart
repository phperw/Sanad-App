import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import 'package:sanad/core/networking/api_result.dart';

import '../data/models/nearby_mission.dart';
import '../data/nearby_missions_repository.dart';
import 'nearby_missions_location.dart';

class NearbyMissionsState {
  final List<NearbyMission> missions;
  final LatLng? position;
  final int? selectedMissionId;
  final int page;
  final bool hasMore;
  final bool isLoadingLocation;
  final bool isLoadingMissions;
  final bool isLoadingMore;
  final int? updatingMissionId;
  final String? errorMessage;
  final String? successMessage;

  const NearbyMissionsState({
    this.missions = const [],
    this.position,
    this.selectedMissionId,
    this.page = 0,
    this.hasMore = false,
    this.isLoadingLocation = false,
    this.isLoadingMissions = false,
    this.isLoadingMore = false,
    this.updatingMissionId,
    this.errorMessage,
    this.successMessage,
  });

  bool get isLoading => isLoadingLocation || isLoadingMissions;

  NearbyMission? get selectedMission {
    for (final mission in missions) {
      if (mission.id == selectedMissionId) return mission;
    }
    return null;
  }

  NearbyMissionsState copyWith({
    List<NearbyMission>? missions,
    LatLng? position,
    int? selectedMissionId,
    bool clearSelectedMission = false,
    int? page,
    bool? hasMore,
    bool? isLoadingLocation,
    bool? isLoadingMissions,
    bool? isLoadingMore,
    int? updatingMissionId,
    bool clearUpdatingMission = false,
    String? errorMessage,
    bool clearError = false,
    String? successMessage,
    bool clearSuccess = false,
  }) {
    return NearbyMissionsState(
      missions: missions ?? this.missions,
      position: position ?? this.position,
      selectedMissionId: clearSelectedMission
          ? null
          : selectedMissionId ?? this.selectedMissionId,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      isLoadingLocation: isLoadingLocation ?? this.isLoadingLocation,
      isLoadingMissions: isLoadingMissions ?? this.isLoadingMissions,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      updatingMissionId: clearUpdatingMission
          ? null
          : updatingMissionId ?? this.updatingMissionId,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      successMessage: clearSuccess
          ? null
          : successMessage ?? this.successMessage,
    );
  }
}

class NearbyMissionsCubit extends Cubit<NearbyMissionsState> {
  final NearbyMissionsRepository _repository;
  final NearbyMissionsLocationProvider _locationProvider;
  final int radiusMeters;
  final int pageSize;
  LatLng? _lastPosition;

  NearbyMissionsCubit(
    this._repository,
    this._locationProvider, {
    this.radiusMeters = 5000,
    this.pageSize = 20,
  }) : super(const NearbyMissionsState());

  Future<void> loadNearby() async {
    if (state.isLoading) return;
    emit(
      state.copyWith(
        isLoadingLocation: true,
        isLoadingMissions: true,
        clearError: true,
        clearSuccess: true,
      ),
    );
    try {
      final position = await _locationProvider.currentPosition();
      if (isClosed) return;
      _lastPosition = position;
      emit(
        state.copyWith(
          position: position,
          isLoadingLocation: false,
          clearError: true,
        ),
      );
      await _fetchPage(1, append: false);
    } on NearbyMissionsLocationException catch (error) {
      if (isClosed) return;
      emit(
        state.copyWith(
          isLoadingLocation: false,
          isLoadingMissions: false,
          errorMessage: error.message,
          clearSuccess: true,
        ),
      );
    } catch (_) {
      if (isClosed) return;
      emit(
        state.copyWith(
          isLoadingLocation: false,
          isLoadingMissions: false,
          errorMessage: 'تعذر تحديد موقعك. حاول مرة أخرى.',
          clearSuccess: true,
        ),
      );
    }
  }

  Future<void> refresh() async {
    final position = _lastPosition;
    if (position == null) {
      await loadNearby();
      return;
    }
    if (state.isLoading) return;
    emit(
      state.copyWith(
        isLoadingMissions: true,
        clearError: true,
        clearSuccess: true,
      ),
    );
    await _fetchPage(1, append: false);
  }

  Future<void> loadMore() async {
    final position = _lastPosition;
    if (position == null ||
        !state.hasMore ||
        state.isLoading ||
        state.isLoadingMore) {
      return;
    }
    emit(
      state.copyWith(
        isLoadingMore: true,
        clearError: true,
        clearSuccess: true,
      ),
    );
    await _fetchPage(state.page + 1, append: true);
  }

  void selectMission(int missionId) {
    emit(
      state.copyWith(
        selectedMissionId: missionId,
        clearError: true,
        clearSuccess: true,
      ),
    );
  }

  Future<void> joinMission(int missionId) async {
    final mission = _missionById(missionId);
    if (mission == null || !mission.canJoin || state.updatingMissionId != null) {
      return;
    }
    emit(
      state.copyWith(
        updatingMissionId: missionId,
        clearError: true,
        clearSuccess: true,
      ),
    );
    final result = await _repository.joinMission(missionId);
    if (isClosed) return;
    switch (result) {
      case Success():
        _replaceMission(mission.withJoinStatus('pending'));
        emit(
          state.copyWith(
            clearUpdatingMission: true,
            successMessage: 'تم إرسال طلب الانضمام. يمكنك إلغاؤه قبل الموافقة.',
            clearError: true,
          ),
        );
      case Failure(:final error):
        emit(
          state.copyWith(
            clearUpdatingMission: true,
            errorMessage: error.message,
            clearSuccess: true,
          ),
        );
    }
  }

  Future<void> cancelJoinRequest(int missionId) async {
    final mission = _missionById(missionId);
    if (mission == null ||
        !mission.isJoinPending ||
        state.updatingMissionId != null) {
      return;
    }
    emit(
      state.copyWith(
        updatingMissionId: missionId,
        clearError: true,
        clearSuccess: true,
      ),
    );
    final result = await _repository.cancelJoinRequest(missionId);
    if (isClosed) return;
    switch (result) {
      case Success():
        _replaceMission(mission.withJoinStatus(null));
        emit(
          state.copyWith(
            clearUpdatingMission: true,
            successMessage: 'تم إلغاء طلب الانضمام.',
            clearError: true,
          ),
        );
      case Failure(:final error):
        emit(
          state.copyWith(
            clearUpdatingMission: true,
            errorMessage: error.message,
            clearSuccess: true,
          ),
        );
    }
  }

  NearbyMission? _missionById(int id) {
    for (final mission in state.missions) {
      if (mission.id == id) return mission;
    }
    return null;
  }

  void _replaceMission(NearbyMission updated) {
    final missions = state.missions
        .map((mission) => mission.id == updated.id ? updated : mission)
        .toList();
    emit(state.copyWith(missions: missions));
  }

  Future<void> _fetchPage(int page, {required bool append}) async {
    final position = _lastPosition;
    if (position == null) return;
    final result = await _repository.getNearbyMissions(
      latitude: position.latitude,
      longitude: position.longitude,
      radiusMeters: radiusMeters,
      page: page,
      limit: pageSize,
    );
    if (isClosed) return;
    switch (result) {
      case Success(:final data):
        final missions = append
            ? [...state.missions, ...data.missions]
            : data.missions;
        final selectedId = missions.any(
          (mission) => mission.id == state.selectedMissionId,
        )
            ? state.selectedMissionId
            : missions.isEmpty
            ? null
            : missions.first.id;
        emit(
          state.copyWith(
            missions: missions,
            selectedMissionId: selectedId,
            clearSelectedMission: selectedId == null,
            page: page,
            hasMore: data.hasMore,
            isLoadingMissions: false,
            isLoadingMore: false,
            clearError: true,
          ),
        );
      case Failure(:final error):
        emit(
          state.copyWith(
            isLoadingMissions: false,
            isLoadingMore: false,
            errorMessage: error.message,
            clearSuccess: true,
          ),
        );
    }
  }
}
