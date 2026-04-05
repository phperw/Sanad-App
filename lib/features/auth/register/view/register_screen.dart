import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sanad/core/di/dependency_injection.dart';
import 'package:sanad/features/auth/register/logic/register_cubit.dart';
import 'package:sanad/features/auth/register/view/widget/register_body.dart';
import 'package:sanad/features/auth/register/view/widget/register_cubit_listener.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => getIt<RegisterCubit>(),
      child: Scaffold(
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(),
          child: const RegisterCubitListener(child: RegisterBody()),
        ),
      ),
    );
  }
}
