import 'package:flutter_test/flutter_test.dart';
import 'package:sport_point/core/services/sport_event_store.dart';

void main() {
  group('SportEventStore Tests', () {
    test('currentEvent gibt das aktive Event zurück', () {
      // 1. Arrange: Store Instanz erstellen
      final store = SportEventStore();

      // 2. Act: Aktuelles Event abrufen
      final current = store.currentEvent;

      // 3. Assert: Prüfen, ob ein aktives Event existiert und isCurrent true ist
      expect(current, isNotNull);
      expect(current!.isCurrent, isTrue);
    });

    test('createNewEvent erstellt ein neues Event und setzt es als aktiv', () {
      // 1. Arrange
      final store = SportEventStore();
      final initialCount = store.events.length;

      // 2. Act: Neues Event anlegen
      final newEvent = store.createNewEvent(
        name: 'Sportfest 2026',
        description: 'Test Beschreibung',
        block: 'C',
      );

      // 3. Assert
      expect(store.events.length, equals(initialCount + 1));
      expect(store.currentEvent?.id, equals(newEvent.id));
      expect(store.currentEvent?.name, equals('Sportfest 2026'));
      expect(store.currentEvent?.description, equals('Test Beschreibung'));
      expect(store.currentEvent?.block, equals('C'));
      expect(store.currentEvent?.isCurrent, isTrue);
    });

    test('setCurrentEvent aktiviert das gewählte Event und archiviert andere', () {
      // 1. Arrange
      final store = SportEventStore();
      final archivedList = store.archivedEvents;

      expect(archivedList, isNotEmpty);
      final targetEvent = archivedList.first;

      // 2. Act: Ziel-Event als aktiv setzen
      store.setCurrentEvent(targetEvent.id);

      // 3. Assert
      expect(store.currentEvent?.id, equals(targetEvent.id));
      expect(targetEvent.isCurrent, isTrue);
    });
  });
}