import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sanad/core/networking/api_result.dart';
import 'package:sanad/features/map/data/nearby_missions_repository.dart';

void main() {
  test(
    'requests nearby missions with the supplied GPS and pagination',
    () async {
      final requests = <RequestOptions>[];
      final dio = _interceptingDio(requests);
      final repository = DioNearbyMissionsRepository(dio);

      final result = await repository.getNearbyMissions(
        latitude: 30.0444,
        longitude: 31.2357,
        radiusMeters: 5000,
        page: 2,
        limit: 20,
      );

      expect(result, isA<Success<NearbyMissionsPage>>());
      expect(requests, hasLength(1));
      expect(requests.single.path, '/missions/nearby');
      expect(requests.single.queryParameters, {
        'latitude': 30.0444,
        'longitude': 31.2357,
        'radiusMeters': 5000,
        'page': 2,
        'limit': 20,
      });
    },
  );

  test(
    'join and cancel use the mission endpoints without request bodies',
    () async {
      final requests = <RequestOptions>[];
      final repository = DioNearbyMissionsRepository(
        _interceptingDio(requests),
      );

      final joinResult = await repository.joinMission(42);
      final cancelResult = await repository.cancelJoinRequest(42);

      expect(joinResult, isA<Success<bool>>());
      expect(cancelResult, isA<Success<bool>>());
      expect(requests.map((request) => request.method), ['POST', 'DELETE']);
      expect(requests.map((request) => request.path), [
        '/missions/42/join',
        '/missions/42/join',
      ]);
      expect(requests.every((request) => request.data == null), isTrue);
    },
  );
}

Dio _interceptingDio(List<RequestOptions> requests) {
  final dio = Dio(BaseOptions(baseUrl: 'https://example.test/api'));
  dio.interceptors.add(
    InterceptorsWrapper(
      onRequest: (options, handler) {
        requests.add(options);
        handler.resolve(
          Response(
            requestOptions: options,
            data: {
              'success': true,
              'missions': [
                {
                  'id': 42,
                  'title': 'Mission',
                  'latitude': 30.0,
                  'longitude': 31.0,
                },
              ],
              'joinRequest': {'id': 9},
            },
          ),
        );
      },
    ),
  );
  return dio;
}
