import 'package:flutter/material.dart';

/// Paleta de cores do Tempus — baseada no gradiente roxo do ícone.
class TempusColors {
  TempusColors._();

  // ── Roxos primários (gradiente do ícone) ──────────────────────────
  static const Color lavender = Color(0xFFE6E6FA); // Roxo lavanda claro
  static const Color lavenderLight = Color(0xFFD3D3FF); // Variação mais clara
  static const Color orchid = Color(0xFF967BB6); // Roxo médio
  static const Color deepPurple = Color(0xFF5B2C8B); // Roxo vibrante
  static const Color plum = Color(0xFF342048); // Roxo profundo
  static const Color midnight = Color(0xFF280137); // Roxo meia-noite

  // ── Acentos ───────────────────────────────────────────────────────
  static const Color accent = Color(0xFFBB86FC); // Roxo Material accent
  static const Color accentLight = Color(0xFFD4BBFF);
  static const Color success = Color(0xFF4CAF50); // Verde (pausa)
  static const Color successLight = Color(0xFFC8E6C9);
  static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFEF5350);

  // ── Neutros ───────────────────────────────────────────────────────
  static const Color surface = Color(0xFFF5F0FA); // Fundo claro
  static const Color surfaceDark = Color(0xFF1A1024); // Fundo escuro
  static const Color card = Colors.white;
  static const Color cardDark = Color(0xFF2A1A3A);
  static const Color textPrimary = Color(0xFF1A1024);
  static const Color textSecondary = Color(0xFF6B5B7B);
  static const Color textOnDark = Color(0xFFF5F0FA);
  static const Color textSecDark = Color(0xFFB0A0C0);

  // ── Gradientes ────────────────────────────────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [orchid, deepPurple, midnight],
  );

  static const LinearGradient lightGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [lavender, surface],
  );

  static const LinearGradient darkGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [plum, surfaceDark],
  );

  static const LinearGradient accentGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accent, deepPurple],
  );

  // ── MaterialColor swatch ──────────────────────────────────────────
  static const MaterialColor swatch = MaterialColor(0xFF5B2C8B, <int, Color>{
    50: Color(0xFFEDE7F6),
    100: Color(0xFFD1C4E9),
    200: Color(0xFFB39DDB),
    300: Color(0xFF9575CD),
    400: Color(0xFF7E57C2),
    500: Color(0xFF5B2C8B),
    600: Color(0xFF512DA8),
    700: Color(0xFF4527A0),
    800: Color(0xFF3C1F8E),
    900: Color(0xFF280137),
  });
}
