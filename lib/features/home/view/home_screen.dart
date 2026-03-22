import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sanad/core/routing/router.dart';
import 'package:sanad/features/home/model/mission_model.dart';
import 'package:sanad/features/map/widgets/mission_card_widget.dart';

import 'widget/stats_row.dart';
import 'widget/task_header.dart';
import '../../../core/helper/responsive_extensions.dart';
import '../../../core/helper/spacing.dart';
import 'widget/header_section.dart';
import 'widget/news_section.dart';
import 'widget/sos_button.dart';
import '../../../core/constants/app_images.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(Assets.backgroundSplashScreen),
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 16.w(context)),
            children: [
              const HeaderSection(),
              verticalSpace(context, height: 20),
              const SOSButton(),
              verticalSpace(context, height: 20),
              const StatsRow(),
              verticalSpace(context, height: 20),
              const NewsSection(),
              verticalSpace(context, height: 20),

              // Dynamic header matching our list length
              TasksHeader(tasksCount: dummyMissions.length),
              verticalSpace(context, height: 16),

              // Inside your Home Screen ListView:
              ...dummyMissions.map<Widget>((mission) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 12.h(context)),
                  child: MapMissionCard(
                    title: mission.title,
                    distance: mission.distance,
                    isActive: mission.isActive,
                    onTap: () {
                      context.push(AppRouter.kcampaignDetails);
                    },
                  ),
                );
              }).toList(),

              verticalSpace(context, height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
