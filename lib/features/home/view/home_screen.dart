import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanad/core/di/dependency_injection.dart';
import 'package:sanad/features/home/logic/home_cubit.dart';
import 'package:sanad/features/home/view/widget/home_body.dart';
import 'package:sanad/features/home/view/widget/home_cubit_listener.dart';

class HomeScreen extends StatelessWidget {
  final VoidCallback? onMissionReportSubmitted;

  const HomeScreen({super.key, this.onMissionReportSubmitted});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<HomeCubit>()..getHomeData(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: HomeCubitListener(
            child: HomeBody(onMissionReportSubmitted: onMissionReportSubmitted),
          ),
        ),
      ),
    );
  }
}
