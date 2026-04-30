import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/theme_provider.dart';

class CosmicTheme {
  // --- ICONIC PALETTE (Original) ---
  static const Color iconicDarkBackground = Color(0xFF111319);
  static const Color iconicDarkSurfaceLowest = Color(0xFF0B0E14);
  static const Color iconicDarkSurfaceHigh = Color(0xFF272A30);
  static const Color iconicDarkPrimary = Color(0xFF1565C0);
  static const Color iconicDarkSecondary = Color(0xFF00897B);
  static const Color iconicOnSurface = Color(0xFFE1E2EA);
  static const Color iconicOnSurfaceVariant = Color(0xFFC2C6D4);

  // --- SLATE PALETTE ---
  static const Color slateDarkBackground = Color(0xFF1B1E26);
  static const Color slateDarkSurfaceLowest = Color(0xFF12141A);
  static const Color slateDarkSurfaceHigh = Color(0xFF2D323E);
  static const Color slateDarkPrimary = Color(0xFF5C7285);
  static const Color slateDarkSecondary = Color(0xFF9195F6);

  // --- NEBULA PALETTE ---
  static const Color nebulaDarkBackground = Color(0xFF0F0C29);
  static const Color nebulaDarkSurfaceLowest = Color(0xFF070515);
  static const Color nebulaDarkSurfaceHigh = Color(0xFF302B63);
  static const Color nebulaDarkPrimary = Color(0xFF8E2DE2); // Vibrant Violet for visibility
  static const Color nebulaDarkSecondary = Color(0xFFEE0979);

  // --- LIGHT BASE (Shared) ---
  static const Color lightBackground = Color(0xFFF8F9FF);
  static const Color lightSurfaceLowest = Color(0xFFEEF0FA);
  static const Color lightSurfaceHigh = Color(0xFFE1E2EC);
  static const Color lightOnSurface = Color(0xFF191C20);
  static const Color lightOnSurfaceVariant = Color(0xFF43474E);

  static ThemeData getTheme(bool isDark, PalettePreset preset) {
    Color background;
    Color surfaceLowest;
    Color surfaceHigh;
    Color primary;
    Color secondary;
    Color onSurface;
    Color onSurfaceVariant;

    if (isDark) {
      onSurface = iconicOnSurface;
      onSurfaceVariant = iconicOnSurfaceVariant;
      switch (preset) {
        case PalettePreset.slate:
          background = slateDarkBackground;
          surfaceLowest = slateDarkSurfaceLowest;
          surfaceHigh = slateDarkSurfaceHigh;
          primary = slateDarkPrimary;
          secondary = slateDarkSecondary;
          break;
        case PalettePreset.nebula:
          background = nebulaDarkBackground;
          surfaceLowest = nebulaDarkSurfaceLowest;
          surfaceHigh = nebulaDarkSurfaceHigh;
          primary = nebulaDarkPrimary;
          secondary = nebulaDarkSecondary;
          break;
        case PalettePreset.iconic:
          background = iconicDarkBackground;
          surfaceLowest = iconicDarkSurfaceLowest;
          surfaceHigh = iconicDarkSurfaceHigh;
          primary = iconicDarkPrimary;
          secondary = iconicDarkSecondary;
          break;
      }
    } else {
      background = lightBackground;
      surfaceLowest = lightSurfaceLowest;
      surfaceHigh = lightSurfaceHigh;
      primary = iconicDarkPrimary; // Use iconic primary for light base
      secondary = iconicDarkSecondary;
      onSurface = lightOnSurface;
      onSurfaceVariant = lightOnSurfaceVariant;
    }

    return ThemeData(
      useMaterial3: true,
      brightness: isDark ? Brightness.dark : Brightness.light,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme(
        brightness: isDark ? Brightness.dark : Brightness.light,
        primary: primary,
        onPrimary: Colors.white,
        secondary: secondary,
        onSecondary: Colors.white,
        surface: background,
        onSurface: onSurface,
        surfaceContainerLowest: surfaceLowest,
        surfaceContainerHigh: surfaceHigh,
        outlineVariant: onSurfaceVariant.withOpacity(0.15),
        error: const Color(0xFF93000A),
        onError: Colors.white,
        onSurfaceVariant: onSurfaceVariant,
      ),
      textTheme: GoogleFonts.interTextTheme().copyWith(
        displayLarge: GoogleFonts.spaceGrotesk(
          fontSize: 56,
          fontWeight: FontWeight.bold,
          color: onSurface,
        ),
        headlineMedium: GoogleFonts.spaceGrotesk(
          fontSize: 24,
          fontWeight: FontWeight.w600,
          color: onSurface,
        ),
        bodyLarge: GoogleFonts.inter(
          fontSize: 18,
          color: onSurface,
        ),
        bodyMedium: GoogleFonts.inter(
          fontSize: 16,
          color: onSurfaceVariant,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
          statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
        ),
        titleTextStyle: GoogleFonts.spaceGrotesk(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: onSurface,
        ),
      ),
    );
  }

  // Tokens for easy access (using currently selected isDark and preset context)
  static Color darkSurfaceLowest = iconicDarkSurfaceLowest;
  static Color darkSurfaceHigh = iconicDarkSurfaceHigh;
  static Color darkPrimary = iconicDarkPrimary;
  static Color darkOnSurface = iconicOnSurface;
  static Color darkOnSurfaceVariant = iconicOnSurfaceVariant;

  // Since static members can't react to state, we should use a helper method in the widget
  // --- Static Aliases for backward compatibility ---
  static const Color darkSecondary = iconicDarkSecondary;
  static const Color darkTertiary = Color(0xFFFFB68C);
  static const Color lightPrimary = iconicDarkPrimary; // Shared for light
  static const Color lightSecondary = Color(0xFF006A60);
  static const Color lightTertiary = Color(0xFF8F4E00);
}
