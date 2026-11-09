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

  /// Rahmenfarbe für Eingabefelder und Dropdowns.
  static const Color inputBorder = Color(0xFF475569);

  /// Dezentere Textfarbe für Untertitel und Nebeninformationen.
  static const Color textMuted = Color(0xFF939494);
}
