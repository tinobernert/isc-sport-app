import 'package:flutter_test/flutter_test.dart';
import 'package:sport_point/features/create_event/domain/models/sport_event_model.dart';

void main() {
  group('SportEventModel Tests', () {
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

    test('copyWith erstellt eine korrekte Kopie mit geänderten Event-Werten', () {
      final original = SportEventModel(
        id: 2,
        name: 'Altes Event',
        description: 'Alte Beschreibung',
        block: 'B',
        date: DateTime(2025, 1, 1),
        isCurrent: false,
      );

      final copied = original.copyWith(name: 'Neues Event', isCurrent: true);

      expect(copied.id, equals(original.id));
      expect(copied.name, equals('Neues Event'));
      expect(copied.description, equals('Alte Beschreibung')); // unverändert
      expect(copied.isCurrent, isTrue);
    });

    test('Negativ-Test: Prüft, dass abweichende Werte nicht übereinstimmen', () {
      final event = SportEventModel(
        id: 1,
        name: 'TestEvent',
        description: 'TestEvent Beschreibung',
        block: 'A',
        date: DateTime(2025, 6, 15),
        isCurrent: false,
      );

      expect(event.isCurrent, isFalse);
    });
  });
}
