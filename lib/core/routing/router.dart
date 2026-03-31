import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sanad/core/networking/api_service.dart';
import 'package:sanad/features/auth/forget/forget_view.dart';
import 'package:sanad/features/auth/login/view/login_screen.dart';
import 'package:sanad/features/auth/login/view_model/login/login_cubit.dart';
import 'package:sanad/features/auth/register/view/register_screen.dart';
import 'package:sanad/features/auth/register/view_model/register_cubit.dart';
import 'package:sanad/features/home/view_model/home/home_cubit.dart';
import 'package:sanad/features/onboarding/ui/on_boarding_screen.dart';
import 'package:sanad/features/splash/ui/splash_screen.dart';
import 'package:sanad/features/main/view/main_screen.dart';

import '../../features/attendance/view/attendance_confirmation_screen.dart';
import '../../features/campaign/view/campaign_details_screen.dart';
import '../../features/report/campaign_report_screen.dart';
import '../../features/report_success_delivery/widgets/report_success_screen.dart';
import '../../features/success_checkin/success_checkin_screen.dart';

class AppRouter {
  static const kstart = '/star';
  static const klogin = '/login';
  static const kregister = '/register';
  static const kforget = '/forget';
  static const konboarding = '/onboarding';
  static const kmain = '/main';
  static const khome = '/main';
  static const kmap = '/main';
  static const kchat = '/main';
  static const kaccount = '/main';
  static const kAttendanceConfirmation = '/attendanceConfirmation';
  static const kCampaignDetails = '/campaignDetails';
  static const kSuccessCheckin = '/successCheckin';
  static const kCampaignReport = '/campaignReport';
  static const kReportSuccess = '/reportSuccess';

  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: kstart,
    routes: [
      GoRoute(path: kstart, builder: (context, state) => const SplashScreen()),
      GoRoute(
        path: konboarding,
        builder: (context, state) => const OnBoardingScreen(),
      ),
      GoRoute(
        path: klogin,
        builder: (context, state) => BlocProvider(
          create: (context) => LoginCubit(ApiDioService()),
          child: LoginScreen(),
        ),
      ),
      GoRoute(
        path: kregister,
        builder: (context, state) => BlocProvider(
          create: (context) => RegisterCubit(ApiDioService()),
          child: RegisterScreen(),
        ),
      ),
      GoRoute(path: kforget, builder: (context, state) => const ForgetView()),
      GoRoute(
        path: kmain,
        builder: (context, state) => BlocProvider(
          create: (context) => HomeCubit(ApiDioService())..getHomeSummary(),
          child: const MainScreen(),
        ),
      ),
      GoRoute(
        path: kAttendanceConfirmation,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const AttendanceConfirmationScreen(),
      ),
      GoRoute(
        path: kCampaignDetails,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const CampaignDetailsScreen(),
      ),
      GoRoute(
        path: kSuccessCheckin,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SuccessCheckinScreen(),
      ),
      GoRoute(
        path: kCampaignReport,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const CampaignReportScreen(),
      ),
      GoRoute(
        path: kReportSuccess,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ReportSuccessScreen(),
      ),
    ],
  );
}
