import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xFF1F3A5F),
      ),
      appBarTheme: const AppBarTheme(
        centerTitle: true,
      ),
    );
  }
}
