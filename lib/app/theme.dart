import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lign_financial/core/themes/app_colors.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      scaffoldBackgroundColor: LignColors.primaryBackground,
      colorScheme: const ColorScheme.light(
        primary: LignColors.electricLime,
        onPrimary: LignColors.textPrimary, // Black text on Lime
        secondary: LignColors.electricLime,
        onSecondary: LignColors.textPrimary,
        surface: LignColors.cardSurface,
        onSurface: LignColors.textPrimary,
        error: LignColors.error,
        onError: Colors.white,
      ),
      textTheme: GoogleFonts.interTextTheme().copyWith(
        displayLarge: const TextStyle(
          color: LignColors.textPrimary,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.5,
        ),
        displayMedium: const TextStyle(
          color: LignColors.textPrimary,
          fontWeight: FontWeight.bold,
          letterSpacing: -0.5,
        ),
        bodyLarge: const TextStyle(
          color: LignColors.textPrimary,
        ),
        bodyMedium: const TextStyle(
          color: LignColors.textSecondary,
        ),
      ),
      // Button Theme
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: LignColors.electricLime,
          foregroundColor: LignColors.textPrimary,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
          elevation: 0,
        ),
      ),
      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: LignColors.textSecondary,
          side: const BorderSide(color: LignColors.border),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      // Card Theme
      cardTheme: CardThemeData(
        color: LignColors.cardSurface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: LignColors.border),
        ),
        margin: EdgeInsets.zero,
      ),
      // Input Decoration Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: LignColors.primaryBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: LignColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: LignColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: LignColors.electricLime, width: 2),
        ),
        labelStyle: const TextStyle(color: LignColors.textSecondary),
        hintStyle: const TextStyle(color: LignColors.textDisabled),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      ),
    );
  }
}
