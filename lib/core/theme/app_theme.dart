import 'package:flutter/material.dart';

class AppTheme {
  AppTheme._();

  static ThemeData light = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF005FFF),
    ),
    appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
  );

  static ThemeData dark = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF005FFF),
      brightness: Brightness.dark,
    ),
    appBarTheme: const AppBarTheme(centerTitle: true, elevation: 0),
  );
}