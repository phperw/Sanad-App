import 'package:flutter/material.dart';
import 'package:sanad/features/home/view/widget/header_section.dart';
import 'package:sanad/features/home/view/widget/news_section.dart';
import 'package:sanad/features/home/view/widget/sos_button.dart';
import 'package:sanad/features/home/view/widget/status_card.dart';
import 'package:sanad/features/home/view/widget/task_section.dart';
// الشاشة الرئيسية اللي هتحوي كل البوتوم ناف والشاشات

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
              HeaderSection(),
              verticalSpace(context, height: 20),
              SOSButton(),
              verticalSpace(context, height: 20),
              StatsRow(),
              verticalSpace(context, height: 20),
              NewsSection(),
              verticalSpace(context, height: 20),
              TasksHeader(tasksCount: 2),
              verticalSpace(context, height: 16),
              ScheduledTaskCard(
                time: 'AM 10:00',
                remainingTime: 'متبقي 2س',
                locationName: 'منطقة أكتوبر السكنية',
                taskType: 'مهمة ميدانية سريعة',
              ),
              verticalSpace(context, height: 12),
              ScheduledTaskCard(
                time: 'PM 2:30',
                remainingTime: 'متبقي 5س',
                locationName: 'حي المعادي - شارع 9',
                taskType: 'دعم لوجستي و توزيع',
              ),
              verticalSpace(context, height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
