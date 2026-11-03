// Ein Enum verhindert ungültige Werte für die Richtung.
enum Richtung { hochGut, niedrigGut }

class Disziplinen {
  final String name;
  final String einheit;
  final Richtung richtung;
  final double gewichtung;

  const Disziplinen({
    required this.name,
    required this.einheit,
    required this.richtung,
    required this.gewichtung,
  });
}
