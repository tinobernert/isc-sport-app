import 'package:flutter_test/flutter_test.dart';
import 'package:sport_point/features/create_event/domain/models/sport_event_model.dart';

void main() {
  group('EventModel Tests', () {
    test('Erstellt ein EventModel und prüft die Eigenschaften', () {
      final event = SportEventModel(
        id: 'event_active_1',
        name: 'TestEvent',
        description: 'TestEvent Beschreibung',
        block: 'A',
        date: DateTime(2025, 6, 15),
        isCurrent: true,
      );

      expect(event.name, equals('TestEvent'));
      expect(event.description, equals('TestEvent Beschreibung'));
      expect(event.block, equals('A'));
      expect(event.date, equals(DateTime(2025, 6, 15)));
      expect(event.isCurrent, isTrue);

    });
  });
}
