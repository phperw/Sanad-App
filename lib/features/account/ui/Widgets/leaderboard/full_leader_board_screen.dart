import 'package:flutter/material.dart';
import 'package:sanad/core/theme/app_colors.dart';
import 'package:sanad/core/theme/text_styles.dart';
import 'package:sanad/core/helper/responsive_extensions.dart';
import 'package:sanad/core/helper/spacing.dart';
import 'package:sanad/features/account/ui/Widgets/leaderboard/time_filter_tab_bar.dart';
import 'views/all_time/all_time_leaderboard_view.dart';
import 'views/monthly/monthly_leaderboard_view.dart';
import 'views/weekly/weekly_leaderboard_view.dart';

class FullLeaderBoardScreen extends StatefulWidget {
  const FullLeaderBoardScreen({super.key});

  @override
  State<FullLeaderBoardScreen> createState() => _FullLeaderBoardScreenState();
}

class _FullLeaderBoardScreenState extends State<FullLeaderBoardScreen> {
  int _currentIndex = 0;

  final List<Widget> _views = const [
    WeeklyLeaderboardView(),
    MonthlyLeaderboardView(),
    AllTimeLeaderboardView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.scaffoldThemed(context),
      appBar: AppBar(
        backgroundColor: AppColors.transparent,
        elevation: 0,
        centerTitle: true,
        title: Text(
          'لوحة المتصدرين',
          style: TextStyles.cairoBold16DarkBlue(context),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, size: 24.sp(context)),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w(context)),
          child: Column(
            children: [
              TimeFilterTabBar(
                selectedIndex: _currentIndex,
                onTabChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
              ),
              verticalSpace(context, height: 16),
              Expanded(
                child: IndexedStack(index: _currentIndex, children: _views),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
