import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Centralized class defining the visual theme and constants of the application.
class AppTheme {
  // Brand colors used throughout the app.
  static const Color backgroundColor = Color(0xFF0B0B0F);
  static const Color surfaceColor = Color(0xFF1C1C24);
  static const Color accentPurple = Color(0xFF8E2DE2);
  static const Color accentRed = Color(0xFFFF4D4D);
  static const Color textPrimary = Colors.white;
  static const Color textSecondary = Colors.grey;

  /// Defines the application's global dark theme.
  /// Sets colors, fonts, and component styles.
  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    scaffoldBackgroundColor: backgroundColor,
    primaryColor: accentPurple,
    cardColor: surfaceColor,
    // Uses Google Fonts for more consistent and modern typography.
    textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
    colorScheme: const ColorScheme.dark(
      primary: accentPurple,
      secondary: accentRed,
      surface: surfaceColor,
      background: backgroundColor,
    ),
  );
}
