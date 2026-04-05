import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/helper/shared_pref_helper.dart';

class ThemeCubit extends Cubit<bool> {
  ThemeCubit() : super(SharedPrefHelper.isDarkMode());

  Future<void> toggleTheme() async {
    final newTheme = !state;
    await SharedPrefHelper.saveThemeMode(newTheme);
    emit(newTheme);
  }

  // ───────── COLORS ─────────

  // 🌙 Dark Mode Colors (الموحدة)
  static const Color darkBg = Color(0xFF13131F);
  static const Color darkSurface = Color(0xFF1E1E2E);
  static const Color darkOnSurface = Color(0xFFE8E8E8);
  static const Color darkNavBg = Color(0xFF13131F);

  // ☀️ Light Mode Colors
  static const Color lightBg = Color(0xFFF5F7FA);

  // ───────── LIGHT THEME ─────────
  ThemeData get lightTheme => ThemeData(
    brightness: Brightness.light,
    scaffoldBackgroundColor: lightBg,
    colorScheme: const ColorScheme.light(
      primary: Color(0xFF188A55),
      secondary: Color(0xFF5EC8D8),
      surface: Colors.white,
      onSurface: Color(0xFF111827),
      onPrimary: Colors.white,
    ),
    cardColor: Colors.white,
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Color(0xFF111827),
      elevation: 0,
    ),
    bottomSheetTheme: const BottomSheetThemeData(backgroundColor: Colors.white),
    dialogBackgroundColor: Colors.white,
    dividerColor: const Color(0xFFE5E7EB),
    fontFamily: 'Cairo',
  );

  // ───────── DARK THEME ─────────
  ThemeData get darkTheme => ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: darkBg,
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF188A55),
      secondary: Color(0xFF5EC8D8),
      surface: darkSurface,
      onSurface: darkOnSurface,
      onPrimary: Colors.white,
    ),
    cardColor: darkSurface,
    appBarTheme: const AppBarTheme(
      backgroundColor: darkBg,
      foregroundColor: darkOnSurface,
      elevation: 0,
    ),
    bottomSheetTheme: const BottomSheetThemeData(backgroundColor: darkSurface),
    dialogBackgroundColor: darkSurface,
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: darkSurface,
      hintStyle: TextStyle(color: Colors.grey.shade600),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF2A2A3E)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF2A2A3E)),
      ),
    ),
    dividerColor: const Color(0xFF2A2A3E),
    fontFamily: 'Cairo',
  );
}
