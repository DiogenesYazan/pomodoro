import 'package:flutter/material.dart';
import 'tempus_colors.dart';

/// Tema centralizado do Tempus — light & dark.
class TempusTheme {
  TempusTheme._();

  // ── Tipografia compartilhada ──────────────────────────────────────
  static const String _fontFamily = 'Segoe UI'; // fallback do sistema

  static TextTheme _buildTextTheme(Color primary, Color secondary) {
    return TextTheme(
      displayLarge: TextStyle(
        fontSize: 48,
        fontWeight: FontWeight.w700,
        color: primary,
        letterSpacing: -1,
      ),
      displayMedium: TextStyle(
        fontSize: 36,
        fontWeight: FontWeight.w700,
        color: primary,
      ),
      headlineLarge: TextStyle(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: primary,
      ),
      headlineMedium: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: primary,
      ),
      titleLarge: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: primary,
      ),
      titleMedium: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: primary,
      ),
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: primary,
      ),
      bodyMedium: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: secondary,
      ),
      labelLarge: TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: primary,
        letterSpacing: 0.5,
      ),
      labelSmall: TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: secondary,
      ),
    );
  }

  // ── Card / Shape ──────────────────────────────────────────────────
  static final _cardShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(16),
  );

  static final _buttonShape = RoundedRectangleBorder(
    borderRadius: BorderRadius.circular(14),
  );

  // ══════════════════════════════════════════════════════════════════
  //  LIGHT THEME
  // ══════════════════════════════════════════════════════════════════
  static ThemeData get light {
    final textTheme = _buildTextTheme(
      TempusColors.textPrimary,
      TempusColors.textSecondary,
    );

    return ThemeData(
      useMaterial3: true,
      fontFamily: _fontFamily,
      brightness: Brightness.light,
      primaryColor: TempusColors.deepPurple,
      colorScheme: ColorScheme.light(
        primary: TempusColors.deepPurple,
        onPrimary: Colors.white,
        secondary: TempusColors.accent,
        onSecondary: Colors.white,
        surface: TempusColors.surface,
        onSurface: TempusColors.textPrimary,
        error: TempusColors.error,
      ),
      scaffoldBackgroundColor: TempusColors.surface,
      textTheme: textTheme,

      // AppBar
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: TempusColors.textPrimary,
        titleTextStyle: textTheme.titleLarge,
      ),

      // Cards
      cardTheme: CardThemeData(
        elevation: 2,
        shadowColor: TempusColors.deepPurple.withAlpha(30),
        shape: _cardShape,
        color: TempusColors.card,
      ),

      // Elevated Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: TempusColors.deepPurple,
          foregroundColor: Colors.white,
          elevation: 2,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          shape: _buttonShape,
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),

      // Outlined Buttons
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: TempusColors.deepPurple,
          side: const BorderSide(color: TempusColors.orchid, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          shape: _buttonShape,
        ),
      ),

      // Icon Buttons
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: TempusColors.deepPurple,
        ),
      ),

      // Bottom Nav
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: TempusColors.deepPurple,
        unselectedItemColor: TempusColors.textSecondary,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle:
            const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
      ),

      // Slider
      sliderTheme: SliderThemeData(
        activeTrackColor: TempusColors.deepPurple,
        thumbColor: TempusColors.deepPurple,
        inactiveTrackColor: TempusColors.lavender,
        overlayColor: TempusColors.accent.withAlpha(40),
      ),

      // Switch
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected))
            return TempusColors.deepPurple;
          return TempusColors.orchid;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected))
            return TempusColors.lavender;
          return TempusColors.surface;
        }),
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: Color(0xFFE0D8E8),
        thickness: 1,
      ),
    );
  }

  // ══════════════════════════════════════════════════════════════════
  //  DARK THEME
  // ══════════════════════════════════════════════════════════════════
  static ThemeData get dark {
    final textTheme = _buildTextTheme(
      TempusColors.textOnDark,
      TempusColors.textSecDark,
    );

    return ThemeData(
      useMaterial3: true,
      fontFamily: _fontFamily,
      brightness: Brightness.dark,
      primaryColor: TempusColors.accent,
      colorScheme: ColorScheme.dark(
        primary: TempusColors.accent,
        onPrimary: TempusColors.midnight,
        secondary: TempusColors.orchid,
        onSecondary: Colors.white,
        surface: TempusColors.surfaceDark,
        onSurface: TempusColors.textOnDark,
        error: TempusColors.error,
      ),
      scaffoldBackgroundColor: TempusColors.surfaceDark,
      textTheme: textTheme,

      // AppBar
      appBarTheme: AppBarTheme(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        foregroundColor: TempusColors.textOnDark,
        titleTextStyle: textTheme.titleLarge,
      ),

      // Cards
      cardTheme: CardThemeData(
        elevation: 4,
        shadowColor: Colors.black26,
        shape: _cardShape,
        color: TempusColors.cardDark,
      ),

      // Elevated Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: TempusColors.accent,
          foregroundColor: TempusColors.midnight,
          elevation: 4,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          shape: _buttonShape,
          textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
      ),

      // Outlined Buttons
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: TempusColors.accent,
          side: const BorderSide(color: TempusColors.orchid, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
          shape: _buttonShape,
        ),
      ),

      // Icon Buttons
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          foregroundColor: TempusColors.accent,
        ),
      ),

      // Bottom Nav
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: TempusColors.cardDark,
        selectedItemColor: TempusColors.accent,
        unselectedItemColor: TempusColors.textSecDark,
        type: BottomNavigationBarType.fixed,
        elevation: 8,
        selectedLabelStyle:
            const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        unselectedLabelStyle: const TextStyle(fontSize: 12),
      ),

      // Slider
      sliderTheme: SliderThemeData(
        activeTrackColor: TempusColors.accent,
        thumbColor: TempusColors.accent,
        inactiveTrackColor: TempusColors.plum,
        overlayColor: TempusColors.accent.withAlpha(40),
      ),

      // Switch
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return TempusColors.accent;
          return TempusColors.orchid;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) return TempusColors.plum;
          return TempusColors.surfaceDark;
        }),
      ),

      // Divider
      dividerTheme: const DividerThemeData(
        color: Color(0xFF3A2A4A),
        thickness: 1,
      ),
    );
  }
}
