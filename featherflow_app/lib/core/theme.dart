import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const primary = Color(0xFF01291E);
  static const primaryLight = Color(0xFF024A37);
  static const primaryDark = Color(0xFF011810);
  static const accent = Color(0xFF4CAF82);
  static const accentLight = Color(0xFF6FCF97);
  static const gold = Color(0xFFF4C552);
  static const surface = Color(0xFFF7FAF8);
  static const cardBg = Color(0xFFFFFFFF);
  static const textPrimary = Color(0xFF0D1F1A);
  static const textSecondary = Color(0xFF5C7268);
  static const textMuted = Color(0xFF9BB5AD);
  static const danger = Color(0xFFE53935);
  static const warning = Color(0xFFFFA726);
  static const info = Color(0xFF29B6F6);

  static ThemeData theme = ThemeData(
    primaryColor: primary,
    scaffoldBackgroundColor: surface,
    colorScheme: const ColorScheme.light(
      primary: primary,
      secondary: accent,
      surface: cardBg,
      error: danger,
    ),
    textTheme: GoogleFonts.plusJakartaSansTextTheme().copyWith(
      displayLarge: GoogleFonts.playfairDisplay(
        color: textPrimary,
        fontWeight: FontWeight.w700,
      ),
      displayMedium: GoogleFonts.playfairDisplay(
        color: textPrimary,
        fontWeight: FontWeight.w600,
      ),
      headlineLarge: GoogleFonts.plusJakartaSans(
        color: textPrimary,
        fontWeight: FontWeight.w700,
      ),
      headlineMedium: GoogleFonts.plusJakartaSans(
        color: textPrimary,
        fontWeight: FontWeight.w600,
      ),
      bodyLarge: GoogleFonts.plusJakartaSans(color: textPrimary),
      bodyMedium: GoogleFonts.plusJakartaSans(color: textSecondary),
    ),
    appBarTheme: AppBarTheme(
      backgroundColor: primary,
      foregroundColor: Colors.white,
      elevation: 0,
      titleTextStyle: GoogleFonts.playfairDisplay(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w600,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: primary,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        textStyle: GoogleFonts.plusJakartaSans(
          fontWeight: FontWeight.w600,
          fontSize: 15,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFD4E4DF)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFD4E4DF)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: accent, width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    ),
    cardTheme: CardThemeData(
      color: cardBg,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Color(0xFFE8F0EC)),
      ),
    ),
  );
}