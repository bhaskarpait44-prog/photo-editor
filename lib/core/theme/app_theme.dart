import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: const Color(0xFF0A0A0A), // Background
      colorScheme: const ColorScheme.dark(
        surface: Color(0xFF1A1A1A), // Surface
        primary: Color(0xFFFF6B35), // Accent (orange)
        secondary: Color(0xFF888888), // Text secondary
        onSurface: Color(0xFFFFFFFF), // Text primary
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF141414), // Panel
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: Color(0xFFFFFFFF)),
        titleTextStyle: TextStyle(
          color: Color(0xFFFFFFFF),
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
      ),
      cardTheme: CardThemeData(
        color: const Color(0xFF1A1A1A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: Color(0xFFFF6B35),
        foregroundColor: Colors.white,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: Color(0xFF141414),
        selectedItemColor: Color(0xFFFF6B35),
        unselectedItemColor: Color(0xFF888888),
      ),
      iconTheme: const IconThemeData(
        color: Color(0xFFFFFFFF),
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: Color(0xFFFFFFFF)),
        bodyMedium: TextStyle(color: Color(0xFFFFFFFF)),
        bodySmall: TextStyle(color: Color(0xFF888888)),
      ),
    );
  }
}
