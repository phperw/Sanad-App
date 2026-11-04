import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../account/logic/theme_cubit.dart';
import '../../account/ui/account_screen.dart';
import '../../chats_and_community/ui/chats_and_community_screen.dart';
import '../../home/view/home_screen.dart';
import '../../../core/helper/responsive_extensions.dart';
import '../../map/view/map_home_screen.dart';
import 'package:solar_icons/solar_icons.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;
  final List<bool> _visited = [true, false, false, false];
  final GlobalKey<AccountScreenState> _accountScreenKey =
      GlobalKey<AccountScreenState>();

  late final List<Widget> _screens = [
    HomeScreen(
      onMissionReportSubmitted: () {
        _accountScreenKey.currentState?.refreshProfile();
      },
    ),
    const MapScreen(),
    const ChatsAndCommunityScreen(),
    AccountScreen(key: _accountScreenKey),
  ];

  Widget _solarIcon(BuildContext context, IconData icon, bool isActive) {
    return Icon(
      icon,
      size: 22.r(context),
      color: isActive ? AppColors.primaryColor : AppColors.gray,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, bool>(
      builder: (context, isDark) {
        final navBgColor = isDark ? ThemeCubit.darkNavBg : AppColors.white;

        return Scaffold(
          extendBody: true,
          body: Stack(
            children: List.generate(_screens.length, (index) {
              if (!_visited[index]) return const SizedBox.shrink();
              return Offstage(
                offstage: currentIndex != index,
                child: _screens[index],
              );
            }),
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: navBgColor,
              boxShadow: const [
                BoxShadow(
                  blurRadius: 16,
                  color: Colors.black12,
                  offset: Offset(0, -2),
                ),
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 12.w(context),
                  vertical: 12.h(context),
                ),
                child: GNav(
                  haptic: true,
                  curve: Curves.easeOutExpo,
                  duration: const Duration(milliseconds: 400),
                  gap: 6.w(context),
                  color: AppColors.gray,
                  activeColor: AppColors.primaryColor,
                  iconSize: 22.sp(context),
                  tabBackgroundColor: AppColors.primaryColor.withValues(
                    alpha: 0.09,
                  ),
                  tabBorderRadius: 50.r(context),
                  tabActiveBorder: Border.all(
                    color: AppColors.primaryColor.withValues(alpha: 0.2),
                    width: 1,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w(context),
                    vertical: 10.h(context),
                  ),
                  selectedIndex: currentIndex,
                  onTabChange: (index) {
                    setState(() {
                      _visited[index] = true;
                      currentIndex = index;
                    });
                    if (index == 3) {
                      _accountScreenKey.currentState?.refreshProfile();
                    }
                  },
                  tabs: [
                    GButton(
                      icon: SolarIconsOutline.home,
                      leading: _solarIcon(
                        context,
                        SolarIconsOutline.home,
                        currentIndex == 0,
                      ),
                      text: 'الرئيسية',
                      textStyle: TextStyles.cairoBold10Primary(context),
                    ),
                    GButton(
                      icon: SolarIconsOutline.map,
                      leading: _solarIcon(
                        context,
                        SolarIconsOutline.map,
                        currentIndex == 1,
                      ),
                      text: 'الخريطة',
                      textStyle: TextStyles.cairoBold10Primary(context),
                    ),
                    GButton(
                      icon: SolarIconsOutline.chatRoundLine,
                      leading: _solarIcon(
                        context,
                        SolarIconsOutline.chatRoundLine,
                        currentIndex == 2,
                      ),
                      text: 'محادثاتي',
                      textStyle: TextStyles.cairoBold10Primary(context),
                    ),
                    GButton(
                      icon: SolarIconsOutline.user,
                      leading: _solarIcon(
                        context,
                        SolarIconsOutline.user,
                        currentIndex == 3,
                      ),
                      text: 'حسابي',
                      textStyle: TextStyles.cairoBold10Primary(context),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
