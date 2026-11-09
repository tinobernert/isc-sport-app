import 'package:flutter/material.dart';

/// Zentrale Farbdefinitionen der SportPoint-Anwendung.
///
/// Alle im Projekt verwendeten Farben sollten aus dieser Klasse
/// oder aus dem [ColorScheme] bezogen werden, um ein einheitliches Designsystem
/// zu gewährleisten.
abstract class AppColors {
  /// Hauptfarbe der Anwendung (Orange).
  static const Color primary = Color(0xFFFF8134);

  /// Heller Akzent- bzw. Hintergrundfarbton für Cards und AppBars.
  static const Color primaryLight = Color(0xFFFFEADD);

  /// Hintergrundfarbe der Screens.
  static const Color background = Colors.white;

  /// Text- und Icon-Farbe auf primärem Hintergrund.
  static const Color onPrimary = Colors.white;

  /// Rahmenfarbe für Eingabefelder und Dropdowns.
  static const Color inputBorder = Color(0xFF475569);

  /// Dezentere Textfarbe für Untertitel und Nebeninformationen.
  static const Color textMuted = Color(0xFF939494);
}
