import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/text_styles.dart';
import '../../home/view/home_screen.dart';
import '../../../core/constants/app_images.dart';
import '../../../core/helper/responsive_extensions.dart';

import 'package:sanad/core/theme/app_colors.dart';
import 'package:sanad/features/home/view/home_screen.dart';
import 'package:sanad/features/map/view/map_home_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int currentIndex = 0;

  // 2. Replaced the placeholder MapScreen with our real MapView
  final List<Widget> screens = [
    const HomeScreen(),
    const MapScreen(),
    const ChatScreen(),
    const HomeScreen(),
    const MapHomeScreen(), // <--- Our new Map Screen!
    const ChatScreen(),
    const AccountScreen(),
  ];

  Widget _svgIcon(BuildContext context, String path, bool isActive) {
    return SvgPicture.asset(
      path,
      width: 22.w(context),
      height: 22.h(context),
      colorFilter: ColorFilter.mode(
        isActive ? AppColors.primaryColor : AppColors.gray,
        BlendMode.srcIn,
      ),
    );
  }
  ];

  final List<IconData> icons = [
    Icons.home_outlined,
    Icons.map_outlined,
    Icons.chat_bubble_outline,
    Icons.person_outline, // Changed to outline to match the design
  ];

  final List<String> labels = ["الرئيسية", "الخريطة", "محادثاتي", "حسابي"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(index: currentIndex, children: screens),
      body: IndexedStack(index: currentIndex, children: screens),
      bottomNavigationBar: Container(
        height: 80, // Made slightly taller for better breathing room
        decoration: const BoxDecoration(
          color: AppColors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 16,
              color: Colors.black12,
              offset: Offset(0, -2),
            ),
              offset: Offset(0, -2), // Shadow points up slightly
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
              tabBackgroundColor: AppColors.primaryColor.withOpacity(0.08),
              tabBorderRadius: 50.r(context),
              tabActiveBorder: Border.all(
                color: AppColors.primaryColor.withOpacity(0.3),
                width: 1,
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 16.w(context),
                vertical: 10.h(context),
              ),
              selectedIndex: currentIndex,
              onTabChange: (index) => setState(() => currentIndex = index),
              tabs: [
                GButton(
                  icon: Icons.home_outlined,
                  leading: _svgIcon(context, Assets.home, currentIndex == 0),
                  text: 'الرئيسية',
                  textStyle: TextStyles.cairoBold10Primary(context),
                ),
                GButton(
                  icon: Icons.map_outlined,
                  leading: _svgIcon(context, Assets.map, currentIndex == 1),
                  text: 'الخريطة',
                  textStyle: TextStyles.cairoBold10Primary(context),
                ),
                GButton(
                  icon: Icons.chat_bubble_outline,
                  leading: _svgIcon(context, Assets.messageCircle, currentIndex == 2),
                  text: 'محادثاتي',
                  textStyle: TextStyles.cairoBold10Primary(context),
                ),
                GButton(
                  icon: Icons.person_outline,
                  leading: _svgIcon(context, Assets.account, currentIndex == 3),
                  text: 'حسابي',
                  textStyle: TextStyles.cairoBold10Primary(context),
                ),
              ],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(
            icons.length,
            (index) => GestureDetector(
              behavior:
                  HitTestBehavior.opaque, // Makes the whole area clickable
              onTap: () {
                setState(() {
                  currentIndex = index;
                });
              },
              child: SizedBox(
                width: 70,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    // 3. Moved the green indicator to the TOP to match your design image
                    Container(
                      height: 3,
                      width: 35,
                      decoration: BoxDecoration(
                        color: currentIndex == index
                            ? AppColors.primaryColor
                            : Colors.transparent,
                        borderRadius: const BorderRadius.only(
                          bottomLeft: Radius.circular(10),
                          bottomRight: Radius.circular(10),
                        ),
                      ),
                    ),
                    const Spacer(),

                    Icon(
                      icons[index],
                      color: currentIndex == index
                          ? AppColors.primaryColor
                          : AppColors.gray,
                    ),
                    const SizedBox(height: 4),

                    Text(
                      labels[index],
                      style: TextStyle(
                        fontSize: 12,
                        fontFamily: 'Cairo', // Applied your font
                        fontWeight: currentIndex == index
                            ? FontWeight.w700
                            : FontWeight.w400,
                        color: currentIndex == index
                            ? AppColors.primaryColor
                            : AppColors.gray,
                      ),
                    ),
                    const SizedBox(height: 10), // Bottom padding
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("حسابي")),
      body: const Center(child: Text("هذه شاشة حسابي")),
    );
  }
}

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("محادثاتي")),
      body: const Center(child: Text("هذه شاشة المحادثات")),
    );
  }
}

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("الخريطة")),
      body: const Center(child: Text("هذه شاشة الخريطة")),
    );
  }
}
// Notice: I completely removed the dummy MapScreen class from here so it doesn't conflict!
