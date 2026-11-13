import 'package:flutter_test/flutter_test.dart';
import 'package:sport_point/features/create_event/data/datasources/event_local_datasource.dart';
import 'package:sport_point/features/create_event/data/repositories/event_repository.dart';

void main() {
  group('EventRepository Tests', () {
    test('getCurrentEvent liefert das aktive Event vom DataSource', () {
      // 1. Arrange
      final dataSource = EventLocalDataSourceImpl();
      final repository = EventRepository(localDataSource: dataSource);

      // 2. Act
      final current = repository.getCurrentEvent();

      // 3. Assert
      expect(current, isNotNull);
      expect(current!.isCurrent, isTrue);
    });

    test('getArchivedEvents liefert alle inaktiven Events', () {
      final dataSource = EventLocalDataSourceImpl();
      final repository = EventRepository(localDataSource: dataSource);

      final archived = repository.getArchivedEvents();

      expect(archived, isNotEmpty);
      for (final event in archived) {
        expect(event.isCurrent, isFalse);
      }
    });

    test('createNewEvent im Repository legt ein neues Event an', () {
      // 1. Arrange
      final dataSource = EventLocalDataSourceImpl();
      final repository = EventRepository(localDataSource: dataSource);
      final initialCount = repository.getEvents().length;

      // 2. Act
      final newEvent = repository.createNewEvent(
        name: 'Repo Test Event',
        description: 'Test Beschreibung',
        block: 'B',
      );

      // 3. Assert
      expect(repository.getEvents().length, equals(initialCount + 1));
      expect(repository.getCurrentEvent()?.id, equals(newEvent.id));
      expect(repository.getCurrentEvent()?.name, equals('Repo Test Event'));
      expect(repository.getCurrentEvent()?.isCurrent, isTrue);
    });

    test('setCurrentEvent ändert das aktive Event im Repository', () {
      final dataSource = EventLocalDataSourceImpl();
      final repository = EventRepository(localDataSource: dataSource);

      final archived = repository.getArchivedEvents();
      final target = archived.first;

      repository.setCurrentEvent(target.id);

      expect(repository.getCurrentEvent()?.id, equals(target.id));
      expect(target.isCurrent, isTrue);
    });

    test('updateEvent aktualisiert ein Event im Repository', () {
      final dataSource = EventLocalDataSourceImpl();
      final repository = EventRepository(localDataSource: dataSource);

      final current = repository.getCurrentEvent()!;
      final updated = current.copyWith(name: 'Updated Repo Event');

      repository.updateEvent(updated);

      expect(repository.getCurrentEvent()?.name, equals('Updated Repo Event'));
    });
  });
}
