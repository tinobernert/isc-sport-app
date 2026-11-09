import '../models/disziplin.dart';

/// Eine Testliste mit vordefinierten Disziplinen für Entwicklungs- und Testzwecke.
const testDisziplinen = [
  Disziplin(
    name: 'Weitsprung',
    einheit: 'm',
    richtung: Richtung.hoch,
    gewichtung: 1.0,
  ),
  Disziplin(
    name: 'Sprint',
    einheit: 's',
    richtung: Richtung.niedrig,
    gewichtung: 1.0,
  ),
  Disziplin(
    name: 'Kugelstoßen',
    einheit: 'm',
    richtung: Richtung.hoch,
    gewichtung: 1.5,
  ),
  Disziplin(
    name: 'Hochsprung',
    einheit: 'cm',
    richtung: Richtung.hoch,
    gewichtung: 1.0,
  ),
  Disziplin(
    name: 'Staffellauf',
    einheit: 's',
    richtung: Richtung.niedrig,
    gewichtung: 2.0,
  ),
];
