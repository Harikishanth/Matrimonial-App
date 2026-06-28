import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class KalyaThiruTheme {
  // Brand Colors
  static const Color primaryMaroon = Color(0xFF800020);
  static const Color primaryDark = Color(0xFF570013);
  static const Color softIvory = Color(0xFFFDFBF7);
  static const Color darkCharcoal = Color(0xFF1D1B19);
  static const Color mutedGray = Color(0xFF8A7973);
  static const Color outlineBorder = Color(0xFF8C7071);
  static const Color outlineVariant = Color(0x338C7071);
  static const Color antiqueGold = Color(0xFFD4AF37);
  static const Color surfaceCard = Colors.white;

  // Gradients (Aura system)
  static const LinearGradient auraGold = LinearGradient(
    colors: [
      Color(0xFFBF953F),
      Color(0xFFFCF6BA),
      Color(0xFFB38728),
      Color(0xFFFBF5B7),
      Color(0xFFAA771C),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient auraSilver = LinearGradient(
    colors: [
      Color(0xFFB5B5B5),
      Color(0xFFF5F5F5),
      Color(0xFF9E9E9E),
      Color(0xFFE0E0E0),
      Color(0xFF8A8A8A),
    ],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: primaryMaroon,
      scaffoldBackgroundColor: softIvory,
      colorScheme: const ColorScheme.light(
        primary: primaryMaroon,
        secondary: antiqueGold,
        surface: Colors.white,
        onPrimary: Colors.white,
        onSecondary: primaryDark,
        onSurface: darkCharcoal,
        error: Color(0xFFBA1A1A),
      ),
      textTheme: TextTheme(
        // Source Serif 4 for headlines
        displayLarge: GoogleFonts.sourceSerif4(
          fontSize: 40,
          fontWeight: FontWeight.bold,
          color: primaryMaroon,
          height: 1.2,
        ),
        headlineLarge: GoogleFonts.sourceSerif4(
          fontSize: 30,
          fontWeight: FontWeight.w600,
          color: primaryMaroon,
          height: 1.3,
        ),
        headlineMedium: GoogleFonts.sourceSerif4(
          fontSize: 22,
          fontWeight: FontWeight.w600,
          color: darkCharcoal,
          height: 1.3,
        ),
        titleLarge: GoogleFonts.sourceSerif4(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: darkCharcoal,
        ),
        // Nunito Sans for body
        bodyLarge: GoogleFonts.nunitoSans(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: darkCharcoal,
          height: 1.5,
        ),
        bodyMedium: GoogleFonts.nunitoSans(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: darkCharcoal,
          height: 1.4,
        ),
        labelLarge: GoogleFonts.nunitoSans(
          fontSize: 13,
          fontWeight: FontWeight.bold,
          letterSpacing: 1.2,
          color: primaryMaroon,
        ),
        labelMedium: GoogleFonts.nunitoSans(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: mutedGray,
        ),
      ),
      cardTheme: const CardThemeData(
        color: surfaceCard,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: outlineVariant, width: 1),
          borderRadius: BorderRadius.all(Radius.circular(4)), // Crisp 4px borders
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.transparent,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: outlineBorder, width: 1),
          borderRadius: BorderRadius.circular(4),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: primaryMaroon, width: 1.5),
          borderRadius: BorderRadius.circular(4),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFFBA1A1A), width: 1),
          borderRadius: BorderRadius.circular(4),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFFBA1A1A), width: 1.5),
          borderRadius: BorderRadius.circular(4),
        ),
        labelStyle: GoogleFonts.nunitoSans(color: mutedGray, fontSize: 14),
        floatingLabelStyle: GoogleFonts.nunitoSans(color: primaryMaroon, fontSize: 12, fontWeight: FontWeight.bold),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryMaroon,
          foregroundColor: Colors.white,
          elevation: 2,
          shadowColor: const Color(0x33570013),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4), // Crisp 4px borders
          ),
          textStyle: GoogleFonts.nunitoSans(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            letterSpacing: 1.0,
          ),
        ),
      ),
    );
  }
}
