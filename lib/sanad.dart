// import 'package:flutter/material.dart';
// import 'core/routing/router.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';

// class Sanad extends StatelessWidget {
//   const Sanad({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp.router(
//       title: 'Sanad',
//       debugShowCheckedModeBanner: false,
//       routerConfig: AppRouter.router,
//       locale: const Locale('ar'),
//       supportedLocales: const [Locale('ar')],
//       localizationsDelegates: const [
//         GlobalMaterialLocalizations.delegate,
//         GlobalWidgetsLocalizations.delegate,
//         GlobalCupertinoLocalizations.delegate,
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/routing/router.dart';
import 'features/account/logic/theme_cubit.dart';

class Sanad extends StatelessWidget {
  const Sanad({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ThemeCubit(),
      child: BlocBuilder<ThemeCubit, bool>(
        builder: (context, isDark) {
          final themeCubit = context.read<ThemeCubit>();
          return MaterialApp.router(
            title: 'Sanad',
            debugShowCheckedModeBanner: false,
            routerConfig: AppRouter.router,
            // ✅ ربط الـ theme بالـ ThemeCubit
            theme: themeCubit.lightTheme,
            darkTheme: themeCubit.darkTheme,
            themeMode: isDark ? ThemeMode.dark : ThemeMode.light,
            locale: const Locale('ar'),
            supportedLocales: const [Locale('ar')],
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
          );
        },
      ),
    );
  }
}
