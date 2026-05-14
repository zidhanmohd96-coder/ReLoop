import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  static const Color forestGreen = Color(0xFF1B4332);
  static const Color leafGreen = Color(0xFF2D6A4F);
  static const Color lightGreen = Color(0xFF40916C);
  static const Color softBeige = Color(0xFFF8F9FA);
  static const Color earthBrown = Color(0xFF6C584C);

  static BoxDecoration getClayDecoration({
    Color color = Colors.white,
    double borderRadius = 32,
  }) {
    final isDark = color.computeLuminance() < 0.5;
    return BoxDecoration(
      color: color.withOpacity(0.95), // Slight glass effect
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: isDark
            ? Colors.white.withOpacity(0.1)
            : Colors.white.withOpacity(0.8),
        width: 1.5,
      ),
      boxShadow: [
        BoxShadow(
          color: isDark
              ? Colors.black.withOpacity(0.3)
              : Colors.black.withOpacity(0.08),
          offset: const Offset(6, 6),
          blurRadius: 16,
          spreadRadius: 0,
        ),
        BoxShadow(
          color: isDark
              ? Colors.white.withOpacity(0.02)
              : Colors.white.withOpacity(0.9),
          offset: const Offset(-6, -6),
          blurRadius: 16,
          spreadRadius: 0,
        ),
      ],
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      primaryColor: leafGreen,
      scaffoldBackgroundColor: softBeige,
      colorScheme: ColorScheme.light(
        primary: leafGreen,
        secondary: lightGreen,
        surface: Colors.white,
        onPrimary: Colors.white,
      ),
      textTheme: GoogleFonts.interTextTheme().copyWith(
        displayLarge: GoogleFonts.outfit(
          fontWeight: FontWeight.bold,
          color: forestGreen,
        ),
        displayMedium: GoogleFonts.outfit(
          fontWeight: FontWeight.bold,
          color: forestGreen,
        ),
        titleLarge: GoogleFonts.outfit(
          fontWeight: FontWeight.w600,
          color: forestGreen,
        ),
        bodyLarge: GoogleFonts.inter(color: Colors.black87),
        bodyMedium: GoogleFonts.inter(color: Colors.black87),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: Colors.white,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: leafGreen,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: GoogleFonts.outfit(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: leafGreen, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
    );
  }
}
