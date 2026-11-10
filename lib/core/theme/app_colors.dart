import 'package:flutter/material.dart';

/// Zentrale Farbdefinitionen der SportPoint-Anwendung.

/// Alle im Projekt verwendeten Farben sollten aus dieser Klasse
/// oder aus dem [ColorScheme] bezogen werden, um ein einheitliches Designsystem
/// zu gewährleisten.
abstract class AppColors {
  /// Primäre Akzentfarbe der App (Orange).
  static const Color primary = Color(0xFFFF8134);

  /// Heller Akzent- bzw. Hintergrundfarbton für Cards und AppBars.
  static const Color primaryLight = Color(0xFFFFEADD);

  /// Hintergrundfarbe der Screens.
  static const Color background = Colors.white;

  /// Text- und Icon-Farbe auf primärem Hintergrund.
  static const Color onPrimary = Colors.white;

  /// Rahmenfarbe für Eingabefelder.
  static const Color inputBorder = Color(0xFF475569);

  /// Dezentere Textfarbe für Untertitel.
  static const Color textMuted = Color(0xFF939494);

  /// Medaillen-Farben für Ranglisten.
  static const Color gold = Color(0xFFFFD700);
  static const Color silver = Color(0xFFC0C0C0);
  static const Color bronze = Color(0xFFCD7F32);

  /// Farben für Disziplin-Kategorien.
  static const Color laufCategory = Colors.blue;
  static const Color sprungCategory = Colors.green;
  static const Color wurfCategory = Colors.deepOrange;

  /// Zusätzliche Grautöne und Semantic Colors für ein einheitliches Designsystem.
  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey800 = Color(0xFF424242);

  static const Color successLight = Color(0xFFE8F5E9);
  static const Color successDark = Color(0xFF2E7D32);
  static const Color warningLight = Color(0xFFFFF8E1);
  static const Color warningDark = Color(0xFFF57F17);
}
