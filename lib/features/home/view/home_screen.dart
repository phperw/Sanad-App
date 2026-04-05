import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanad/core/di/dependency_injection.dart';
import 'package:sanad/features/home/logic/home_cubit.dart';
import 'package:sanad/features/home/view/widget/home_body.dart';
import 'package:sanad/features/home/view/widget/home_cubit_listener.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<HomeCubit>()..getHomeData(),
      child: const Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(child: HomeCubitListener(child: HomeBody())),
      ),
    );
  }
}
