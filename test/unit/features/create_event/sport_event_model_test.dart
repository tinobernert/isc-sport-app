import 'package:flutter_test/flutter_test.dart';
import 'package:sport_point/features/create_event/domain/models/sport_event_model.dart';

void main() {
  group('EventModel Tests', () {
    // 1. Positiv-Test: Erstellen mit gültigen Daten
    test('Erstellt ein EventModel und prüft die Eigenschaften', () {
      final event = SportEventModel(
        id: 1,
        name: 'TestEvent',
        description: 'TestEvent Beschreibung',
        block: 'A',
        date: DateTime(2025, 6, 15),
        isCurrent: true,
      );

      expect(event.id, equals(1));
      expect(event.name, equals('TestEvent'));
      expect(event.description, equals('TestEvent Beschreibung'));
      expect(event.block, equals('A'));
      expect(event.date, equals(DateTime(2025, 6, 15)));
      expect(event.isCurrent, isTrue);
    });

    // 2. Negativ-Test: Prüft gezielt auf Ungleichheiten & falsche Erwartungen
    test('Negativ-Test: Prüft, dass abweichende Werte nicht übereinstimmen', () {
      final event = SportEventModel(
        id: 1,
        name: 'TestEvent',
        description: 'TestEvent Beschreibung',
        block: 'A',
        date: DateTime(2025, 6, 15),
        isCurrent: false, // Inaktiv
      );

      // Prüft, dass das Event NICHT aktiv ist
      expect(event.isCurrent, isFalse);

      // Mit `isNot(equals(...))` prüfen wir, dass die ID NICHT 999 entspricht
      expect(event.id, isNot(equals(999)));

      // Prüfen, dass der Name NICHT 'FalscherName' lautet
      expect(event.name, isNot(equals('FalscherName')));
    });
  });
}
