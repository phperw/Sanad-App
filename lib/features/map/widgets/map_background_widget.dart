import 'package:flutter/material.dart';
import 'package:sanad/core/helper/responsive_extensions.dart';

class MapBackgroundWidget extends StatelessWidget {
  const MapBackgroundWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height:
          context.screenHeight *
          0.65, // Takes up 65% of screen to sit behind the sheet
      width: double.infinity,
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage(
            'assets/images/map_placeholder.png',
          ), // Add your map image to assets
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
