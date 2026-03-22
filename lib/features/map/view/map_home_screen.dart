import 'package:flutter/material.dart';
import 'package:sanad/features/home/model/mission_model.dart';
import '../widgets/map_background_widget.dart';
import '../widgets/missions_bottom_sheet_widget.dart';
import '../widgets/search_bar_widget.dart';

class MapHomeScreen extends StatefulWidget {
  const MapHomeScreen({super.key});

  @override
  State<MapHomeScreen> createState() => _MapHomeScreenState();
}

class _MapHomeScreenState extends State<MapHomeScreen> {
  // This list will change as you type
  List<MissionModel> filteredMissions = [];

  @override
  void initState() {
    super.initState();
    filteredMissions = dummyMissions; // Show all at start
  }

  // Inside _MapHomeScreenState
  void _filterMissions(String query) {
    setState(() {
      // We filter the shared dummyMissions list based on the user's typing
      filteredMissions = dummyMissions
          .where((m) => m.title.contains(query) || m.subtitle.contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const MapBackgroundWidget(),
          SearchBarWidget(onChanged: _filterMissions), // Pass the search logic
          MissionsBottomSheetWidget(
            missions: filteredMissions,
          ), // Pass the filtered list
        ],
      ),
    );
  }
}
