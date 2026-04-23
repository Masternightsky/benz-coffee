import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ── Brand Colors (Matches Customer App) ─────────────────────────────
  static const Color primary = Color(0xFF5C3D2E);       // Deep espresso brown
  static const Color primaryLight = Color(0xFF8B6355);  // Medium brown
  static const Color primaryDark = Color(0xFF3B2219);   // Dark roast
  static const Color accent = Color(0xFFC49A6C);        // Warm caramel
  static const Color accentLight = Color(0xFFE8C99A);   // Light caramel
  static const Color background = Color(0xFFFAF5F0);    // Warm cream
  static const Color surface = Color(0xFFF5EDE4);       // Soft beige
  static const Color cardColor = Color(0xFFFFFFFF);     // White cards
  static const Color navBar = Color(0xFF3B2219);        // Dark nav bar

  // ── Text Colors ───────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF2C1810);
  static const Color textSecondary = Color(0xFF8B6355);
  static const Color textLight = Color(0xFFB09080);
  static const Color textOnDark = Color(0xFFFAF5F0);

  // ── Status Colors (Order States) ───────────────────────────────────
  static const Color statusPending = Color(0xFFF5A623);   // Yellow - Pending Payment
  static const Color statusPaid = Color(0xFF2196F3);      // Blue - Paid
  static const Color statusPreparing = Color(0xFFFF9800); // Orange - Preparing
  static const Color statusReady = Color(0xFF4CAF50);     // Green - Ready for Pickup

  // ── Shadow ────────────────────────────────────────────────────────
  static List<BoxShadow> cardShadow = [
    BoxShadow(
      color: primary.withOpacity(0.08),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> buttonShadow = [
    BoxShadow(
      color: primary.withOpacity(0.25),
      blurRadius: 16,
      offset: const Offset(0, 6),
    ),
  ];

  // ── Text Styles ───────────────────────────────────────────────────
  static TextStyle get displayLarge => GoogleFonts.nunitoSans(
        fontSize: 36,
        fontWeight: FontWeight.w700,
        color: textPrimary,
        letterSpacing: -0.5,
      );

  static TextStyle get displayMedium => GoogleFonts.nunitoSans(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      );

  static TextStyle get headingLarge => GoogleFonts.nunitoSans(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: textPrimary,
      );

  static TextStyle get headingMedium => GoogleFonts.lato(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: textPrimary,
      );

  static TextStyle get bodyLarge => GoogleFonts.lato(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: textPrimary,
      );

  static TextStyle get bodyMedium => GoogleFonts.lato(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: textSecondary,
      );

  static TextStyle get bodySmall => GoogleFonts.lato(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: textLight,
      );

  static TextStyle get labelLarge => GoogleFonts.lato(
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: textOnDark,
        letterSpacing: 0.5,
      );

  static TextStyle get orderNumber => GoogleFonts.nunitoSans(
        fontSize: 18,
        fontWeight: FontWeight.w800,
        color: primary,
        letterSpacing: 1,
      );

  static TextStyle get price => GoogleFonts.lato(
        fontSize: 15,
        fontWeight: FontWeight.w700,
        color: accent,
      );

  // ── Theme Data ────────────────────────────────────────────────────
  static ThemeData get theme => ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: primary,
          surface: background,
        ),
        scaffoldBackgroundColor: background,
        appBarTheme: AppBarTheme(
          backgroundColor: navBar,
          foregroundColor: textOnDark,
          elevation: 0,
          titleTextStyle: GoogleFonts.nunitoSans(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: textOnDark,
          ),
          iconTheme: const IconThemeData(color: textOnDark),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: primary,
            foregroundColor: textOnDark,
            minimumSize: const Size(double.infinity, 54),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            textStyle: GoogleFonts.lato(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
            ),
          ),
        ),
      );
}