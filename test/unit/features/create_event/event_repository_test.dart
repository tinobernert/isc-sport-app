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
  });
}
