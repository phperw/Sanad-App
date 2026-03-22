import 'package:flutter/material.dart';
import 'package:sanad/features/map/widgets/map_background_widget.dart';
import 'package:sanad/features/map/widgets/missions_bottom_sheet_widget.dart';
import 'package:sanad/features/map/widgets/search_bar_widget.dart';

class MapHomeScreen extends StatelessWidget {
  const MapHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      // We removed the bottomNavigationBar from here!
      body: Stack(
        children: [
          MapBackgroundWidget(),
          SearchBarWidget(),
          MissionsBottomSheetWidget(),
        ],
      ),
    );
  }
}
