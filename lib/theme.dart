import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // ── Primary Greens ──
  static const Color forestGreen = Color(0xFF1B4332);
  static const Color leafGreen = Color(0xFF2D6A4F);
  static const Color lightGreen = Color(0xFF40916C);
  static const Color mintGreen = Color(0xFF52B788);
  static const Color paleGreen = Color(0xFF95D5B2);

  // ── Accent Colors ──
  static const Color accentTeal = Color(0xFF0D9488);
  static const Color accentEmerald = Color(0xFF10B981);
  static const Color accentAmber = Color(0xFFF59E0B);
  static const Color accentCoral = Color(0xFFF97316);
  static const Color accentRose = Color(0xFFFB7185);
  static const Color accentSky = Color(0xFF38BDF8);
  static const Color accentIndigo = Color(0xFF6366F1);

  // ── Neutrals ──
  static const Color softBeige = Color(0xFFF8F9FA);
  static const Color earthBrown = Color(0xFF6C584C);

  // ── Gradient sets ──
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF1B4332), Color(0xFF2D6A4F), Color(0xFF40916C)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFF0D9488), Color(0xFF10B981)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient warmGradient = LinearGradient(
    colors: [Color(0xFFF59E0B), Color(0xFFF97316)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient lightBgGradient = LinearGradient(
    colors: [Color(0xFFF0FDF4), Color(0xFFECFDF5), Color(0xFFD1FAE5)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  static const LinearGradient darkBgGradient = LinearGradient(
    colors: [Color(0xFF0F172A), Color(0xFF1E293B), Color(0xFF0F172A)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

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

  static BoxDecoration getDarkClayDecoration({
    Color color = const Color(0xFF1E293B),
    double borderRadius = 32,
  }) {
    return BoxDecoration(
      color: color,
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: Colors.white.withOpacity(0.06),
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.4),
          offset: const Offset(4, 4),
          blurRadius: 12,
        ),
        BoxShadow(
          color: Colors.white.withOpacity(0.03),
          offset: const Offset(-2, -2),
          blurRadius: 8,
        ),
      ],
    );
  }

  static ThemeData get lightTheme {
    return ThemeData(
      brightness: Brightness.light,
      primaryColor: leafGreen,
      scaffoldBackgroundColor: softBeige,
      colorScheme: ColorScheme.light(
        primary: leafGreen,
        secondary: lightGreen,
        tertiary: accentTeal,
        surface: Colors.white,
        onPrimary: Colors.white,
        onSurface: forestGreen,
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: forestGreen,
        iconTheme: IconThemeData(color: forestGreen),
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

  static ThemeData get darkTheme {
    const darkSurface = Color(0xFF1E293B);
    const darkBackground = Color(0xFF0F172A);
    const darkCard = Color(0xFF1E293B);
    const darkBorder = Color(0xFF334155);

    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: mintGreen,
      scaffoldBackgroundColor: darkBackground,
      colorScheme: ColorScheme.dark(
        primary: mintGreen,
        secondary: paleGreen,
        tertiary: accentTeal,
        surface: darkSurface,
        onPrimary: darkBackground,
        onSurface: const Color(0xFFE2E8F0),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Color(0xFFE2E8F0),
        iconTheme: IconThemeData(color: Color(0xFFE2E8F0)),
      ),
      textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme).copyWith(
        displayLarge: GoogleFonts.outfit(
          fontWeight: FontWeight.bold,
          color: const Color(0xFFE2E8F0),
        ),
        displayMedium: GoogleFonts.outfit(
          fontWeight: FontWeight.bold,
          color: const Color(0xFFE2E8F0),
        ),
        titleLarge: GoogleFonts.outfit(
          fontWeight: FontWeight.w600,
          color: const Color(0xFFE2E8F0),
        ),
        bodyLarge: GoogleFonts.inter(color: const Color(0xFFCBD5E1)),
        bodyMedium: GoogleFonts.inter(color: const Color(0xFFCBD5E1)),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        color: darkCard,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: mintGreen,
          foregroundColor: darkBackground,
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
        fillColor: darkSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: darkBorder),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: mintGreen, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        labelStyle: const TextStyle(color: Color(0xFF94A3B8)),
        hintStyle: const TextStyle(color: Color(0xFF64748B)),
      ),
    );
  }
}
