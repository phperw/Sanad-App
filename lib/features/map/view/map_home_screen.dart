// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:latlong2/latlong.dart';
// import 'package:sanad/core/networking/dio_factory.dart';
// import 'package:sanad/core/theme/app_colors.dart';

// import '../data/models/nearby_mission.dart';
// import '../data/nearby_missions_repository.dart';
// import '../logic/nearby_missions_cubit.dart';
// import '../logic/nearby_missions_location.dart';

// class MapScreen extends StatelessWidget {
//   final ValueChanged<int>? onMissionSelected;
//   final NearbyMissionsRepository? repository;
//   final NearbyMissionsLocationProvider? locationProvider;

//   const MapScreen({
//     super.key,
//     this.onMissionSelected,
//     this.repository,
//     this.locationProvider,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (_) => NearbyMissionsCubit(
//         repository ?? DioNearbyMissionsRepository(DioFactory.getDio()),
//         locationProvider ?? const GeolocatorNearbyMissionsLocationProvider(),
//       ),
//       child: _NearbyMissionsView(onMissionSelected: onMissionSelected),
//     );
//   }
// }

// class _NearbyMissionsView extends StatelessWidget {
//   final ValueChanged<int>? onMissionSelected;

//   const _NearbyMissionsView({this.onMissionSelected});

//   @override
//   Widget build(BuildContext context) {
//     return BlocConsumer<NearbyMissionsCubit, NearbyMissionsState>(
//       listenWhen: (previous, current) =>
//           previous.errorMessage != current.errorMessage ||
//           previous.successMessage != current.successMessage,
//       listener: (context, state) {
//         final message = state.errorMessage ?? state.successMessage;
//         if (message == null) return;
//         ScaffoldMessenger.of(context)
//           ..hideCurrentSnackBar()
//           ..showSnackBar(SnackBar(content: Text(message)));
//       },
//       builder: (context, state) {
//         final position = state.position;
//         return Directionality(
//           textDirection: TextDirection.rtl,
//           child: Scaffold(
//             body: Stack(
//               children: [
//                 Positioned.fill(
//                   child: position == null
//                       ? const ColoredBox(color: Color(0xffedf1ed))
//                       : _missionsMap(context, state, position),
//                 ),
//                 SafeArea(
//                   child: Align(
//                     alignment: Alignment.topCenter,
//                     child: Padding(
//                       padding: const EdgeInsets.fromLTRB(16, 10, 16, 0),
//                       child: _mapToolbar(context, state),
//                     ),
//                   ),
//                 ),
//                 if (position == null && !state.isLoading)
//                   Positioned(
//                     left: 24,
//                     right: 24,
//                     top: 100,
//                     bottom: MediaQuery.sizeOf(context).height * 0.46,
//                     child: _locationPrompt(context, state),
//                   ),
//                 Align(
//                   alignment: Alignment.bottomCenter,
//                   child: SafeArea(
//                     top: false,
//                     child: Padding(
//                       padding: const EdgeInsets.fromLTRB(10, 0, 10, 8),
//                       child: _missionsPanel(context, state),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }

//   Widget _missionsMap(
//     BuildContext context,
//     NearbyMissionsState state,
//     LatLng position,
//   ) {
//     final mapKey = ValueKey('${position.latitude},${position.longitude}');
//     final markers = <Marker>[
//       for (final mission in state.missions)
//         if (mission.hasCoordinates)
//           Marker(
//             point: LatLng(mission.latitude!, mission.longitude!),
//             width: 48,
//             height: 54,
//             child: GestureDetector(
//               onTap: () => context
//                   .read<NearbyMissionsCubit>()
//                   .selectMission(mission.id),
//               child: Icon(
//                 Icons.location_on,
//                 size: 44,
//                 color: mission.id == state.selectedMissionId
//                     ? AppColors.primaryColor
//                     : const Color(0xff526b60),
//                 shadows: const [
//                   Shadow(color: Colors.white, blurRadius: 4),
//                 ],
//               ),
//             ),
//           ),
//       Marker(
//         point: position,
//         width: 26,
//         height: 26,
//         child: Container(
//           decoration: BoxDecoration(
//             color: Colors.blue.withValues(alpha: 0.2),
//             shape: BoxShape.circle,
//           ),
//           child: Center(
//             child: Container(
//               width: 12,
//               height: 12,
//               decoration: BoxDecoration(
//                 color: Colors.blue,
//                 shape: BoxShape.circle,
//                 border: Border.all(color: Colors.white, width: 2),
//               ),
//             ),
//           ),
//         ),
//       ),
//     ];

//     return FlutterMap(
//       key: mapKey,
//       options: MapOptions(initialCenter: position, initialZoom: 13),
//       children: [
//         TileLayer(
//           urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
//           userAgentPackageName: 'com.sanad.app',
//         ),
//         MarkerLayer(markers: markers),
//         const RichAttributionWidget(
//           attributions: [
//             TextSourceAttribution('© OpenStreetMap contributors'),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _mapToolbar(BuildContext context, NearbyMissionsState state) {
//     final cubit = context.read<NearbyMissionsCubit>();
//     return Material(
//       elevation: 3,
//       color: Theme.of(context).cardColor,
//       borderRadius: BorderRadius.circular(18),
//       child: Padding(
//         padding: const EdgeInsetsDirectional.fromSTEB(16, 10, 8, 10),
//         child: Row(
//           children: [
//             const Icon(Icons.map_outlined, color: AppColors.primaryColor),
//             const SizedBox(width: 8),
//             const Expanded(
//               child: Text(
//                 'المهام القريبة منك',
//                 style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
//               ),
//             ),
//             IconButton(
//               tooltip: state.position == null ? 'تحديد موقعي' : 'تحديث المهام',
//               onPressed: state.isLoading
//                   ? null
//                   : () => state.position == null
//                       ? cubit.loadNearby()
//                       : cubit.refresh(),
//               icon: state.isLoading
//                   ? const SizedBox(
//                       width: 20,
//                       height: 20,
//                       child: CircularProgressIndicator(strokeWidth: 2),
//                     )
//                   : const Icon(Icons.my_location),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _locationPrompt(
//     BuildContext context,
//     NearbyMissionsState state,
//   ) {
//     return Center(
//       child: Card(
//         elevation: 2,
//         child: Padding(
//           padding: const EdgeInsets.all(18),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               const Icon(
//                 Icons.location_searching,
//                 size: 36,
//                 color: AppColors.primaryColor,
//               ),
//               const SizedBox(height: 8),
//               Text(
//                 state.errorMessage ??
//                     'اسمح بالوصول إلى موقعك لعرض المهام القريبة على الخريطة.',
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 12),
//               FilledButton.icon(
//                 onPressed: state.isLoading
//                     ? null
//                     : () => context.read<NearbyMissionsCubit>().loadNearby(),
//                 icon: const Icon(Icons.my_location),
//                 label: const Text('استخدم موقعي'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _missionsPanel(BuildContext context, NearbyMissionsState state) {
//     final height = (MediaQuery.sizeOf(context).height * 0.46).clamp(
//       290.0,
//       420.0,
//     );
//     return Material(
//       elevation: 8,
//       color: Theme.of(context).cardColor,
//       borderRadius: BorderRadius.circular(24),
//       clipBehavior: Clip.antiAlias,
//       child: SizedBox(
//         height: height,
//         child: Column(
//           children: [
//             Padding(
//               padding: const EdgeInsets.fromLTRB(16, 8, 12, 4),
//               child: Row(
//                 children: [
//                   Container(
//                     width: 34,
//                     height: 4,
//                     decoration: BoxDecoration(
//                       color: Theme.of(context).dividerColor,
//                       borderRadius: BorderRadius.circular(4),
//                     ),
//                   ),
//                   const Spacer(),
//                   Text(
//                     state.position == null
//                         ? 'ابدأ باختيار موقعك'
//                         : 'النتائج (${state.missions.length})',
//                     style: const TextStyle(
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   IconButton(
//                     tooltip: 'تحديث',
//                     onPressed: state.isLoading
//                         ? null
//                         : () => context.read<NearbyMissionsCubit>().refresh(),
//                     icon: const Icon(Icons.refresh),
//                   ),
//                 ],
//               ),
//             ),
//             Expanded(child: _panelContent(context, state)),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _panelContent(BuildContext context, NearbyMissionsState state) {
//     if (state.isLoading && state.missions.isEmpty) {
//       return const Center(child: CircularProgressIndicator());
//     }
//     if (state.position == null && state.errorMessage != null) {
//       return Padding(
//         padding: const EdgeInsets.all(16),
//         child: Center(
//           child: Text(state.errorMessage!, textAlign: TextAlign.center),
//         ),
//       );
//     }
//     if (state.position != null && state.missions.isEmpty) {
//       if (state.isLoading) {
//         return const Center(child: CircularProgressIndicator());
//       }
//       if (state.errorMessage != null) {
//         return Center(
//           child: Padding(
//             padding: const EdgeInsets.all(16),
//             child: Text(state.errorMessage!, textAlign: TextAlign.center),
//           ),
//         );
//       }
//       return const Center(child: Text('لا توجد مهام قريبة حاليًا.'));
//     }
//     if (state.missions.isEmpty) {
//       return const Center(child: Text('حدد موقعك لعرض المهام القريبة.'));
//     }
//     return RefreshIndicator(
//       onRefresh: () => context.read<NearbyMissionsCubit>().refresh(),
//       child: ListView.builder(
//         padding: const EdgeInsets.fromLTRB(10, 2, 10, 10),
//         itemCount: state.missions.length + (state.hasMore ? 1 : 0),
//         itemBuilder: (context, index) {
//           if (index >= state.missions.length) {
//             return Padding(
//               padding: const EdgeInsets.symmetric(vertical: 8),
//               child: TextButton(
//                 onPressed: state.isLoadingMore
//                     ? null
//                     : () => context.read<NearbyMissionsCubit>().loadMore(),
//                 child: state.isLoadingMore
//                     ? const SizedBox(
//                         width: 20,
//                         height: 20,
//                         child: CircularProgressIndicator(strokeWidth: 2),
//                       )
//                     : const Text('تحميل المزيد'),
//               ),
//             );
//           }
//           final mission = state.missions[index];
//           return _MissionResultCard(
//             mission: mission,
//             selected: mission.id == state.selectedMissionId,
//             updating: state.updatingMissionId == mission.id,
//             onSelect: () =>
//                 context.read<NearbyMissionsCubit>().selectMission(mission.id),
//             onJoin: () =>
//                 context.read<NearbyMissionsCubit>().joinMission(mission.id),
//             onCancel: () => context
//                 .read<NearbyMissionsCubit>()
//                 .cancelJoinRequest(mission.id),
//             onDetails: onMissionSelected == null
//                 ? null
//                 : () => onMissionSelected!(mission.id),
//           );
//         },
//       ),
//     );
//   }
// }

// class _MissionResultCard extends StatelessWidget {
//   final NearbyMission mission;
//   final bool selected;
//   final bool updating;
//   final VoidCallback onSelect;
//   final VoidCallback onJoin;
//   final VoidCallback onCancel;
//   final VoidCallback? onDetails;

//   const _MissionResultCard({
//     required this.mission,
//     required this.selected,
//     required this.updating,
//     required this.onSelect,
//     required this.onJoin,
//     required this.onCancel,
//     required this.onDetails,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     final title = mission.title?.trim();
//     final location = mission.locationName?.trim();
//     final metadata = [
//       if (location != null && location.isNotEmpty) location,
//       if (mission.distanceMeters != null)
//         _distanceLabel(mission.distanceMeters!),
//       if (mission.date != null) mission.date!,
//       if (mission.startTime != null) mission.startTime!,
//     ].where((part) => part.trim().isNotEmpty).join(' • ');

//     return Card(
//       margin: const EdgeInsets.symmetric(vertical: 4),
//       color: selected
//           ? AppColors.primaryColor.withValues(alpha: 0.06)
//           : theme.cardColor,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(16),
//         side: BorderSide(
//           color: selected ? AppColors.primaryColor : theme.dividerColor,
//           width: selected ? 1.4 : 0.6,
//         ),
//       ),
//       child: InkWell(
//         borderRadius: BorderRadius.circular(16),
//         onTap: onSelect,
//         child: Padding(
//           padding: const EdgeInsets.all(12),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.stretch,
//             children: [
//               Text(
//                 title == null || title.isEmpty ? 'مهمة #${mission.id}' : title,
//                 maxLines: 1,
//                 overflow: TextOverflow.ellipsis,
//                 style: const TextStyle(
//                   fontSize: 14,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               if (metadata.isNotEmpty) ...[
//                 const SizedBox(height: 4),
//                 Text(
//                   metadata,
//                   maxLines: 1,
//                   overflow: TextOverflow.ellipsis,
//                   style: theme.textTheme.bodySmall,
//                 ),
//               ],
//               if (mission.availableSlots != null) ...[
//                 const SizedBox(height: 3),
//                 Text('المقاعد المتاحة: ${mission.availableSlots}'),
//               ],
//               const SizedBox(height: 8),
//               Wrap(
//                 alignment: WrapAlignment.start,
//                 spacing: 8,
//                 runSpacing: 4,
//                 children: [
//                   _joinAction(context),
//                   if (onDetails != null)
//                     TextButton(
//                       onPressed: onDetails,
//                       child: const Text('التفاصيل'),
//                     ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _joinAction(BuildContext context) {
//     if (mission.isJoinPending) {
//       return OutlinedButton(
//         onPressed: updating ? null : onCancel,
//         child: updating
//             ? const _SmallProgressIndicator()
//             : const Text('إلغاء طلب الانضمام'),
//       );
//     }
//     if (mission.isApproved) {
//       return const OutlinedButton(
//         onPressed: null,
//         child: Text('تم قبولك'),
//       );
//     }
//     if (mission.availableSlots == 0) {
//       return const OutlinedButton(
//         onPressed: null,
//         child: Text('اكتملت المقاعد'),
//       );
//     }
//     return FilledButton(
//       onPressed: updating ? null : onJoin,
//       child: updating
//           ? const _SmallProgressIndicator()
//           : const Text('طلب الانضمام'),
//     );
//   }

//   String _distanceLabel(double meters) {
//     if (!meters.isFinite || meters < 0) return '';
//     if (meters < 1000) return '${meters.round()} م';
//     return '${(meters / 1000).toStringAsFixed(1)} كم';
//   }
// }

// class _SmallProgressIndicator extends StatelessWidget {
//   const _SmallProgressIndicator();

//   @override
//   Widget build(BuildContext context) => const SizedBox(
//     width: 18,
//     height: 18,
//     child: CircularProgressIndicator(strokeWidth: 2),
//   );
// }

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:sanad/core/networking/dio_factory.dart';
import 'package:sanad/core/theme/app_colors.dart';

import '../data/models/nearby_mission.dart';
import '../data/nearby_missions_repository.dart';
import '../logic/nearby_missions_cubit.dart';
import '../logic/nearby_missions_location.dart';

class MapScreen extends StatelessWidget {
  final ValueChanged<int>? onMissionSelected;
  final NearbyMissionsRepository? repository;
  final NearbyMissionsLocationProvider? locationProvider;

  const MapScreen({
    super.key,
    this.onMissionSelected,
    this.repository,
    this.locationProvider,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NearbyMissionsCubit(
        repository ?? DioNearbyMissionsRepository(DioFactory.getDio()),
        locationProvider ?? const GeolocatorNearbyMissionsLocationProvider(),
      )..loadNearby(),
      child: _NearbyMissionsView(onMissionSelected: onMissionSelected),
    );
  }
}

class _NearbyMissionsView extends StatelessWidget {
  final ValueChanged<int>? onMissionSelected;

  const _NearbyMissionsView({this.onMissionSelected});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<NearbyMissionsCubit, NearbyMissionsState>(
      listenWhen: (previous, current) =>
          previous.errorMessage != current.errorMessage ||
          previous.successMessage != current.successMessage,
      listener: (context, state) {
        final message = state.errorMessage ?? state.successMessage;
        if (message == null) return;

        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            SnackBar(content: Text(message)),
          );
      },
      builder: (context, state) {
        final position = state.position;

        return Directionality(
          textDirection: TextDirection.rtl,
          child: Scaffold(
            body: Stack(
              children: [
                Positioned.fill(
                  child: position == null
                      ? const ColoredBox(
                          color: Color(0xffedf1ed),
                        )
                      : _missionsMap(context, state, position),
                ),

                SafeArea(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        16,
                        10,
                        16,
                        0,
                      ),
                      child: _mapToolbar(context, state),
                    ),
                  ),
                ),

                if (position == null && !state.isLoading)
                  Positioned(
                    left: 24,
                    right: 24,
                    top: 100,
                    bottom:
                        MediaQuery.sizeOf(context).height * 0.46,
                    child: _locationPrompt(context, state),
                  ),

                Align(
                  alignment: Alignment.bottomCenter,
                  child: SafeArea(
                    top: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        10,
                        0,
                        10,
                        8,
                      ),
                      child: _missionsPanel(context, state),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _missionsMap(
    BuildContext context,
    NearbyMissionsState state,
    LatLng position,
  ) {
    final mapKey = ValueKey(
      '${position.latitude},${position.longitude}',
    );

    final markers = <Marker>[
      for (final mission in state.missions)
        if (mission.hasCoordinates)
          Marker(
            point: LatLng(
              mission.latitude!,
              mission.longitude!,
            ),
            width: 48,
            height: 54,
            child: GestureDetector(
              onTap: () => context
                  .read<NearbyMissionsCubit>()
                  .selectMission(mission.id),
              child: Icon(
                Icons.location_on,
                size: 44,
                color: mission.id == state.selectedMissionId
                    ? AppColors.primaryColor
                    : const Color(0xff526b60),
                shadows: const [
                  Shadow(
                    color: Colors.white,
                    blurRadius: 4,
                  ),
                ],
              ),
            ),
          ),

      Marker(
        point: position,
        width: 26,
        height: 26,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.blue.withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: Colors.blue,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 2,
                ),
              ),
            ),
          ),
        ),
      ),
    ];

    return FlutterMap(
      key: mapKey,
      options: MapOptions(
        initialCenter: position,
        initialZoom: 13,
      ),
      children: [
        TileLayer(
          urlTemplate:
              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.sanad.app',
        ),

        MarkerLayer(markers: markers),

        const RichAttributionWidget(
          showFlutterMapAttribution: false,
          attributions: [
            TextSourceAttribution(
              '© OpenStreetMap contributors',
            ),
          ],
        ),
      ],
    );
  }

  Widget _mapToolbar(
    BuildContext context,
    NearbyMissionsState state,
  ) {
    final cubit = context.read<NearbyMissionsCubit>();

    return Material(
      elevation: 3,
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(
          16,
          10,
          8,
          10,
        ),
        child: Row(
          children: [
            const Icon(
              Icons.map_outlined,
              color: AppColors.primaryColor,
            ),

            const SizedBox(width: 8),

            const Expanded(
              child: Text(
                'المهام القريبة منك',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
            ),

            IconButton(
              tooltip: state.position == null
                  ? 'تحديد موقعي'
                  : 'تحديث المهام',
              onPressed: state.isLoading
                  ? null
                  : () => cubit.refresh(),
              icon: state.isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(Icons.my_location),
            ),
          ],
        ),
      ),
    );
  }

  Widget _locationPrompt(
    BuildContext context,
    NearbyMissionsState state,
  ) {
    return Center(
      child: Card(
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.location_searching,
                size: 36,
                color: AppColors.primaryColor,
              ),

              const SizedBox(height: 8),

              Text(
                state.errorMessage ??
                    'اسمح بالوصول إلى موقعك لعرض المهام القريبة على الخريطة.',
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 12),

              FilledButton.icon(
                onPressed: state.isLoading
                    ? null
                    : () => context
                        .read<NearbyMissionsCubit>()
                        .loadNearby(),
                icon: const Icon(Icons.my_location),
                label: const Text('استخدم موقعي'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _missionsPanel(
    BuildContext context,
    NearbyMissionsState state,
  ) {
    final height = (
      MediaQuery.sizeOf(context).height * 0.46
    ).clamp(290.0, 420.0);

    return Material(
      elevation: 8,
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(24),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        height: height,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 12, 4),
              child: Row(
                children: [
                  Container(
                    width: 34,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Theme.of(context).dividerColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),

                  const Spacer(),

                  Text(
                    state.position == null
                        ? 'ابدأ باختيار موقعك'
                        : 'النتائج (${state.missions.length})',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  IconButton(
                    tooltip: 'تحديث',
                    onPressed: state.isLoading
                        ? null
                        : () => context
                            .read<NearbyMissionsCubit>()
                            .refresh(),
                    icon: const Icon(Icons.refresh),
                  ),
                ],
              ),
            ),

            Expanded(
              child: _panelContent(context, state),
            ),
          ],
        ),
      ),
    );
  }

  Widget _panelContent(
    BuildContext context,
    NearbyMissionsState state,
  ) {
    if (state.isLoading && state.missions.isEmpty) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (state.position == null &&
        state.errorMessage != null) {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Text(
            state.errorMessage!,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (state.position != null &&
        state.missions.isEmpty) {
      if (state.isLoading) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      if (state.errorMessage != null) {
        return Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              state.errorMessage!,
              textAlign: TextAlign.center,
            ),
          ),
        );
      }

      return const Center(
        child: Text('لا توجد مهام قريبة حاليًا.'),
      );
    }

    if (state.missions.isEmpty) {
      return const Center(
        child: Text('حدد موقعك لعرض المهام القريبة.'),
      );
    }

    return RefreshIndicator(
      onRefresh: () =>
          context.read<NearbyMissionsCubit>().refresh(),
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(10, 2, 10, 10),
        itemCount:
            state.missions.length + (state.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= state.missions.length) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: TextButton(
                onPressed: state.isLoadingMore
                    ? null
                    : () => context
                        .read<NearbyMissionsCubit>()
                        .loadMore(),
                child: state.isLoadingMore
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                        ),
                      )
                    : const Text('تحميل المزيد'),
              ),
            );
          }

          final mission = state.missions[index];

          return _MissionResultCard(
            mission: mission,
            selected:
                mission.id == state.selectedMissionId,
            updating:
                state.updatingMissionId == mission.id,
            onSelect: () => context
                .read<NearbyMissionsCubit>()
                .selectMission(mission.id),
            onJoin: () => context
                .read<NearbyMissionsCubit>()
                .joinMission(mission.id),
            onCancel: () => context
                .read<NearbyMissionsCubit>()
                .cancelJoinRequest(mission.id),
            onDetails: onMissionSelected == null
                ? null
                : () => onMissionSelected!(mission.id),
          );
        },
      ),
    );
  }
}

class _MissionResultCard extends StatelessWidget {
  final NearbyMission mission;
  final bool selected;
  final bool updating;
  final VoidCallback onSelect;
  final VoidCallback onJoin;
  final VoidCallback onCancel;
  final VoidCallback? onDetails;

  const _MissionResultCard({
    required this.mission,
    required this.selected,
    required this.updating,
    required this.onSelect,
    required this.onJoin,
    required this.onCancel,
    required this.onDetails,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final title = mission.title?.trim();
    final location = mission.locationName?.trim();

    final metadata = [
      if (location != null && location.isNotEmpty)
        location,
      if (mission.distanceMeters != null)
        _distanceLabel(mission.distanceMeters!),
      if (mission.date != null)
        mission.date!,
      if (mission.startTime != null)
        mission.startTime!,
    ].where((part) => part.trim().isNotEmpty).join(' • ');

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4),
      color: selected
          ? AppColors.primaryColor.withValues(alpha: 0.06)
          : theme.cardColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: selected
              ? AppColors.primaryColor
              : theme.dividerColor,
          width: selected ? 1.4 : 0.6,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onSelect,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                title == null || title.isEmpty
                    ? 'مهمة #${mission.id}'
                    : title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),

              if (metadata.isNotEmpty) ...[
                const SizedBox(height: 4),
                Text(
                  metadata,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall,
                ),
              ],

              if (mission.availableSlots != null) ...[
                const SizedBox(height: 3),
                Text(
                  'المقاعد المتاحة: ${mission.availableSlots}',
                ),
              ],

              const SizedBox(height: 8),

              Wrap(
                alignment: WrapAlignment.start,
                spacing: 8,
                runSpacing: 4,
                children: [
                  _joinAction(context),

                  if (onDetails != null)
                    TextButton(
                      onPressed: onDetails,
                      child: const Text('التفاصيل'),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _joinAction(BuildContext context) {
    if (mission.isJoinPending) {
      return OutlinedButton(
        onPressed: updating ? null : onCancel,
        child: updating
            ? const _SmallProgressIndicator()
            : const Text('إلغاء طلب الانضمام'),
      );
    }

    if (mission.isApproved) {
      return const OutlinedButton(
        onPressed: null,
        child: Text('تم قبولك'),
      );
    }

    if (mission.availableSlots == 0) {
      return const OutlinedButton(
        onPressed: null,
        child: Text('اكتملت المقاعد'),
      );
    }

    return FilledButton(
      onPressed: updating ? null : onJoin,
      child: updating
          ? const _SmallProgressIndicator()
          : const Text('طلب الانضمام'),
    );
  }

  String _distanceLabel(double meters) {
    if (!meters.isFinite || meters < 0) return '';

    if (meters < 1000) {
      return '${meters.round()} م';
    }

    return '${(meters / 1000).toStringAsFixed(1)} كم';
  }
}

class _SmallProgressIndicator extends StatelessWidget {
  const _SmallProgressIndicator();

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 18,
      height: 18,
      child: CircularProgressIndicator(strokeWidth: 2),
    );
  }
}
