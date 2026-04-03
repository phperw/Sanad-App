import 'package:flutter/material.dart';
import 'package:sanad/sanad.dart';
import 'core/di/dependency_injection.dart';
import 'core/helper/shared_pref_helper.dart';
import 'core/widgets/error_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ErrorWidget.builder = (FlutterErrorDetails details) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(child: ErrorScreen(message: details.exceptionAsString())),
      ),
    );
  };

  await SharedPrefHelper.init();
  setupDependencies();
  runApp(const Sanad());
}
