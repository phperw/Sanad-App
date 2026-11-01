import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:sanad/core/routing/router.dart';

import '../../logic/OSO_Cubit/sos_cubit.dart';

class SosBlocListener extends StatelessWidget {
  final Widget child;

  const SosBlocListener({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return BlocListener<SosCubit, SosState>(
      listener: (context, state) {
        if (state is SosSendSuccess) {
          context.go(AppRouter.kSosActive);
        }

        if (state is SosCancelSuccess || state is SosTrackingEnded) {
          context.go(AppRouter.kSosSuccess);
        }

        if (state is SosNoActive) {
          context.go(AppRouter.khome);
        }

        if (state is SosCancelError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error), backgroundColor: Colors.red),
          );
        }
      },
      child: child,
    );
  }
}