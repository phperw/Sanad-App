import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanad/core/networking/dio_factory.dart';
import 'package:sanad/features/campaign/logic/cubit/campaign_cubit.dart';
import 'package:sanad/features/campaign/logic/repo_campaign.dart';
import 'package:sanad/features/map/widgets/map_background_widget.dart';
import 'package:sanad/features/map/widgets/missions_bottom_sheet_widget.dart';
import 'package:sanad/features/map/widgets/search_bar_widget.dart';
class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CampaignsCubit(CampaignsRepo(DioFactory.getDio()))
        ..loadCampaigns(), // ← هنا بيجيب الـ data أول ما الشاشة تفتح
      child: const Scaffold(
        body: Stack(
          children: [
            MapBackgroundWidget(),
            SearchBarWidget(),
            MissionsBottomSheetWidget(),
          ],
        ),
      ),
    );
  }
}
// class MapScreen extends StatelessWidget {
//   const MapScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return const Scaffold(
//       // We removed the bottomNavigationBar from here!
//       body: Stack(
//         children: [
//           MapBackgroundWidget(),
//           SearchBarWidget(),
//           MissionsBottomSheetWidget(),
//         ],
//       ),
//     );
//   }
// }
