import 'package:flutter/material.dart';

class AppThemes {
  // Dark Theme
  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: Color(0xFF4A90E2), // Primary Accent
    scaffoldBackgroundColor: Color(0xFF121212), // Background
    cardColor: Color(0xFF1E1E1E), // Surface / Cards
    colorScheme: ColorScheme.dark(
      primary: Color(0xFF4A90E2), // Primary Accent
      secondary: Color(0xFFF5A623), // Secondary Accent
      surface: Color(0xFF1E1E1E), // Surface
      background: Color(0xFF121212), // Background
      onPrimary: Colors.white, // Text on primary
      onSecondary: Colors.black, // Text on secondary
      onSurface: Colors.white, // Text on surface
      onBackground: Colors.white, // Text on background
      error: Color(0xFFE74C3C), // Error
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Color(0xFF1E1E1E),
      foregroundColor: Colors.white,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF4A90E2),
        foregroundColor: Colors.white,
      ),
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: Colors.white), // Text Primary
      bodyMedium: TextStyle(color: Color(0xFFB3B3B3)), // Text Secondary
    ),
  );

  // Light Theme
  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: Color(0xFF2F80ED), // Primary Accent
    scaffoldBackgroundColor: Color(0xFFF9FAFB), // Background
    cardColor: Colors.white, // Surface / Cards
    colorScheme: ColorScheme.light(
      primary: Color(0xFF2F80ED), // Primary Accent
      secondary: Color(0xFFFFB347), // Secondary Accent
      surface: Colors.white, // Surface
      background: Color(0xFFF9FAFB), // Background
      onPrimary: Colors.white, // Text on primary
      onSecondary: Colors.black, // Text on secondary
      onSurface: Color(0xFF1F2937), // Text on surface
      onBackground: Color(0xFF1F2937), // Text on background
      error: Color(0xFFDC2626), // Error
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: Colors.white,
      foregroundColor: Color(0xFF1F2937),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF2F80ED),
        foregroundColor: Colors.white,
      ),
    ),
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: Color(0xFF1F2937)), // Text Primary
      bodyMedium: TextStyle(color: Color(0xFF6B7280)), // Text Secondary
    ),
  );
}
