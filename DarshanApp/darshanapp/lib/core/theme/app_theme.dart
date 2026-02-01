import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,
    primaryColor: Colors.deepOrange,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.deepOrange,
      brightness: Brightness.light,
    ),
    scaffoldBackgroundColor: Colors.orange[50],
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: Colors.deepOrange,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      iconTheme: IconThemeData(color: Colors.deepOrange),
    ),
    // cardTheme: CardTheme(
    //   elevation: 4,
    //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    //   clipBehavior: Clip.antiAlias,
    // ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,
    primaryColor: Colors.deepOrange,
    colorScheme: ColorScheme.fromSeed(
      seedColor: Colors.deepOrange,
      brightness: Brightness.dark,
      background: const Color(0xFF1A120B), // Deep Warm Black
      surface: const Color(0xFF2D1F16),    // Dark Brown/Wood
      onSurface: const Color(0xFFEDE0D4),  // Warm Off-White
    ),
    scaffoldBackgroundColor: const Color(0xFF1A120B),
    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
      centerTitle: true,
      titleTextStyle: TextStyle(
        color: Color(0xFFEDE0D4),
        fontSize: 22,
        fontWeight: FontWeight.bold,
        letterSpacing: 0.5,
      ),
      iconTheme: IconThemeData(color: Color(0xFFEDE0D4)),
    ),
    // cardTheme: CardTheme(
    //   elevation: 4,
    //   color: const Color(0xFF2D1F16),
    //   surfaceTintColor: Colors.deepOrange.withOpacity(0.1),
    //   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    //   clipBehavior: Clip.antiAlias,
    // ),// ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Color(0xFFEDE0D4)),
      bodyMedium: TextStyle(color: Color(0xFFD7CCC8)), // Softer brown-white
      titleLarge: TextStyle(color: Color(0xFFFFCC80), fontWeight: FontWeight.bold), // Gold-ish title
    ),
  );
}
