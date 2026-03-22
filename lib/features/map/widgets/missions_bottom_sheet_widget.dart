import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sanad/core/helper/responsive_extensions.dart';
import 'package:sanad/features/home/model/mission_model.dart';
import 'mission_card_widget.dart';

class MissionsBottomSheetWidget extends StatelessWidget {
  final List<MissionModel> missions;

  const MissionsBottomSheetWidget({super.key, required this.missions});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        // Height matches your screenshot (approx 42% of screen)
        height: context.screenHeight * 0.42,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFFF2F2F2),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.r(context)),
            topRight: Radius.circular(30.r(context)),
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 15.h(context)),
            const Text(
              'المهام الميدانية',
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10.h(context)),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 16.w(context)),
                itemCount: missions.length,
                itemBuilder: (context, index) {
                  final mission = missions[index];

                  return Padding(
                    padding: EdgeInsets.only(bottom: 12.h(context)),
                    child: MapMissionCard(
                      title: mission.title,
                      distance: mission.distance,
                      // FORCE true for testing if buttons are disabled
                      isActive: mission.isActive,
                      onTap: () {
                        context.push('/campaignDetails');
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
