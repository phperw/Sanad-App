import 'package:go_router/go_router.dart';
// --- Import your Map screen here ---
import 'package:sanad/features/map/view/map_home_screen.dart';

import 'package:sanad/features/attendance/view/attendance_confirmation_screen.dart';
import 'package:sanad/features/auth/forget/forget_view.dart';
import 'package:sanad/features/auth/login/view/login_screen.dart';
import 'package:sanad/features/auth/register/view/register_screen.dart';
import 'package:sanad/features/campaign/view/campaign_details_screen.dart';
import 'package:sanad/features/home/view/home_screen.dart';
import 'package:sanad/features/main/view/main_view.dart';
import 'package:sanad/features/onboarding/ui/on_boarding_screen.dart';
import 'package:sanad/features/report/campaign_report_screen.dart';
import 'package:sanad/features/report_success_delivery/widgets/report_success_screen.dart';
import 'package:sanad/features/splash/ui/splash_screen.dart';
import 'package:sanad/features/success_checkin/success_checkin_screen.dart';

class AppRouter {
  static const kstart = '/star';
  static const klogin = '/login';
  static const kregister = '/register';
  static const kforget = '/forget';
  static const kmain = '/main';
  static const khome = '/home';
  static const konboarding = '/onboarding';
  static const kreportSuccess = '/reportSuccess';
  static const kcampaignDetails = '/campaignDetails';
  static const kattendanceConfirmation = '/attendanceConfirmation';
  static const ksuccessCheckin = '/successCheckin';
  static const kcampaignReport = '/campaignReport';

  // 1. New Map Constant
  static const kmap = '/map';

  static final GoRouter router = GoRouter(
    initialLocation: kstart,
    routes: [
      // 2. Add the Root Route to prevent "no routes for location: /" error
      GoRoute(path: '/', builder: (context, state) => const MainScreen()),

      GoRoute(
        path: konboarding,
        builder: (context, state) => const OnBoardingScreen(),
      ),
      GoRoute(path: kstart, builder: (context, state) => const SplashScreen()),
      GoRoute(path: kforget, builder: (context, state) => const ForgetView()),
      GoRoute(path: kmain, builder: (context, state) => const MainScreen()),
      GoRoute(path: khome, builder: (context, state) => const HomeScreen()),
      GoRoute(path: klogin, builder: (context, state) => const LoginScreen()),
      GoRoute(
        path: kregister,
        builder: (context, state) => const RegisterScreen(),
      ),

      // 3. The New Map Route
      GoRoute(path: kmap, builder: (context, state) => const MapHomeScreen()),

      GoRoute(
        path: kcampaignDetails,
        builder: (context, state) => const CampaignDetailsScreen(),
      ),
      GoRoute(
        path: kattendanceConfirmation,
        builder: (context, state) => const AttendanceConfirmationScreen(),
      ),
      GoRoute(
        path: ksuccessCheckin,
        builder: (context, state) => const SuccessCheckinScreen(),
      ),
      GoRoute(
        path: kcampaignReport,
        builder: (context, state) => const CampaignReportScreen(),
      ),
      GoRoute(
        path: kreportSuccess,
        builder: (context, state) => const ReportSuccessScreen(),
      ),
    ],
  );
}
