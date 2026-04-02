import 'package:flutter/material.dart';
import 'package:sanad/sanad.dart';

import 'core/di/dependency_injection.dart';
import 'core/helper/shared_pref_helper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPrefHelper.init();
  setupDependencies();
  runApp(const Sanad());
}
