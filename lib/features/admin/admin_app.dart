import 'package:flutter/material.dart';
import 'admin_router.dart';

class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    const seedColor = Color(0xFF167C65);
    return MaterialApp.router(
      title: 'أثر - إدارة',
      debugShowCheckedModeBanner: false,
      routerConfig: AdminRouter.router,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: seedColor),
        fontFamily: 'Cairo',
        scaffoldBackgroundColor: const Color(0xFFF4F7F6),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          backgroundColor: Color(0xFFF4F7F6),
        ),
      ),
      builder: (context, child) =>
          Directionality(textDirection: TextDirection.rtl, child: child!),
    );
  }
}
