import 'package:flutter_test/flutter_test.dart';
import 'package:latlong2/latlong.dart';
import 'package:sanad/core/networking/api_result.dart';
import 'package:sanad/features/map/data/models/nearby_mission.dart';
import 'package:sanad/features/map/data/nearby_missions_repository.dart';
import 'package:sanad/features/map/logic/nearby_missions_cubit.dart';
import 'package:sanad/features/map/logic/nearby_missions_location.dart';

void main() {
  group('NearbyMission', () {
    test('parses nearby fields and tolerates missing optional values', () {
      final mission = NearbyMission.fromJson({
        'id': '14',
        'title': 'تنظيف الحي',
        'latitude': '30.04',
        'longitude': 31.23,
        'distanceMeters': 250,
        'availableSlots': 2,
        'userJoinStatus': 'pending',
      });

      expect(mission.id, 14);
      expect(mission.latitude, 30.04);
      expect(mission.longitude, 31.23);
      expect(mission.hasCoordinates, isTrue);
      expect(mission.isJoinPending, isTrue);
      expect(mission.canJoin, isFalse);
      expect(mission.locationName, isNull);
      expect(NearbyMission.fromJson({'id': 15}).hasCoordinates, isFalse);
    });

    test('does not allow joining approved or full missions', () {
      expect(
        NearbyMission.fromJson({
          'id': 1,
          'userJoinStatus': 'approved',
          'availableSlots': 2,
        }).canJoin,
        isFalse,
      );
      expect(
        NearbyMission.fromJson({'id': 2, 'availableSlots': 0}).canJoin,
        isFalse,
      );
      expect(NearbyMission.fromJson({'id': 3}).canJoin, isTrue);
    });
  });

  group('NearbyMissionsCubit', () {
    late _FakeRepository repository;
    late NearbyMissionsCubit cubit;

    setUp(() {
      repository = _FakeRepository();
      cubit = NearbyMissionsCubit(
        repository,
        _FakeLocationProvider(const LatLng(30.0444, 31.2357)),
        pageSize: 2,
      );
    });

    tearDown(() async {
      await cubit.close();
    });

    test('loads using the current GPS position and paginates', () async {
      await cubit.loadNearby();

      expect(repository.requests.single.latitude, 30.0444);
      expect(repository.requests.single.longitude, 31.2357);
      expect(repository.requests.single.page, 1);
      expect(repository.requests.single.limit, 2);
      expect(repository.requests.single.radiusMeters, 5000);
      expect(cubit.state.missions.map((mission) => mission.id), [1, 2]);
      expect(cubit.state.hasMore, isTrue);

      await cubit.loadMore();

      expect(repository.requests.last.page, 2);
      expect(cubit.state.missions.map((mission) => mission.id), [1, 2, 3]);
      expect(cubit.state.hasMore, isFalse);
    });

    test(
      'joins once, permits pending cancellation, and blocks approved join',
      () async {
        await cubit.loadNearby();
        await cubit.joinMission(1);

        expect(repository.joinedMissionIds, [1]);
        expect(cubit.state.missions.first.userJoinStatus, 'pending');
        expect(cubit.state.missions.first.canJoin, isFalse);

        await cubit.cancelJoinRequest(1);

        expect(repository.cancelledMissionIds, [1]);
        expect(cubit.state.missions.first.userJoinStatus, isNull);
        expect(cubit.state.missions.first.canJoin, isTrue);

        await cubit.joinMission(2);
        expect(repository.joinedMissionIds, [1]);
        expect(repository.cancelledMissionIds, [1]);
      },
    );

    test(
      'does not send a nearby request when location permission is denied',
      () async {
        await cubit.close();
        cubit = NearbyMissionsCubit(
          repository,
          _FakeLocationProvider(
            const LatLng(0, 0),
            error: const NearbyMissionsLocationException('permission denied'),
          ),
        );

        await cubit.loadNearby();

        expect(repository.requests, isEmpty);
        expect(cubit.state.position, isNull);
        expect(cubit.state.errorMessage, 'permission denied');
      },
    );
  });
}

class _FakeLocationProvider implements NearbyMissionsLocationProvider {
  final LatLng position;
  final NearbyMissionsLocationException? error;

  const _FakeLocationProvider(this.position, {this.error});

  @override
  Future<LatLng> currentPosition() async {
    if (error != null) throw error!;
    return position;
  }
}

class _NearbyRequest {
  final double latitude;
  final double longitude;
  final int radiusMeters;
  final int page;
  final int limit;

  const _NearbyRequest({
    required this.latitude,
    required this.longitude,
    required this.radiusMeters,
    required this.page,
    required this.limit,
  });
}

class _FakeRepository implements NearbyMissionsRepository {
  final requests = <_NearbyRequest>[];
  final joinedMissionIds = <int>[];
  final cancelledMissionIds = <int>[];

  @override
  Future<ApiResult<NearbyMissionsPage>> getNearbyMissions({
    required double latitude,
    required double longitude,
    required int radiusMeters,
    required int page,
    required int limit,
  }) async {
    requests.add(
      _NearbyRequest(
        latitude: latitude,
        longitude: longitude,
        radiusMeters: radiusMeters,
        page: page,
        limit: limit,
      ),
    );
    final missions = page == 1
        ? [_mission(1), _mission(2, status: 'approved')]
        : [_mission(3)];
    return Success(NearbyMissionsPage(missions: missions, hasMore: page == 1));
  }

  @override
  Future<ApiResult<bool>> joinMission(int taskId) async {
    joinedMissionIds.add(taskId);
    return Success(true);
  }

  @override
  Future<ApiResult<bool>> cancelJoinRequest(int taskId) async {
    cancelledMissionIds.add(taskId);
    return Success(true);
  }

  NearbyMission _mission(int id, {String? status}) => NearbyMission(
    id: id,
    title: 'Mission $id',
    latitude: 30,
    longitude: 31,
    availableSlots: 2,
    userJoinStatus: status,
  );
}
