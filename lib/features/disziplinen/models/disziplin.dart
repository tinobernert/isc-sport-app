/// Gibt an, ob ein höherer oder niedrigerer Wert eine bessere Leistung darstellt.
enum Richtung {
  /// Höhere Werte sind besser (z. B. Weitsprung, Kugelstoßen).
  hoch,

  /// Niedrigere Werte sind besser (z. B. Sprint, Staffellauf).
  niedrig,
}

/// Repräsentiert eine einzelne Sportdisziplin in der Anwendung.
class Disziplin {
  /// Name der Disziplin (z. B. "Weitsprung").
  final String name;

  /// Maßeinheit der Leistung (z. B. "m", "s", "cm").
  final String einheit;

  /// Die Auswertungsrichtung der Leistung (hoch oder niedrig ist besser).
  final Richtung richtung;

  /// Die Gewichtung der Disziplin für die Gesamtpunkteberechnung.
  final double gewichtung;

  /// Erstellt eine neue [Disziplin].
  const Disziplin({
    required this.name,
    required this.einheit,
    required this.richtung,
    required this.gewichtung,
  });
}
