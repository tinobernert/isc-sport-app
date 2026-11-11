import '../datasources/event_local_datasource.dart';
import '../../domain/models/sport_event_model.dart';

/// Repository für den Zugriff auf Sportveranstaltungen gemäß Clean Architecture.
class EventRepository {
  final EventLocalDataSource localDataSource;

  EventRepository({required this.localDataSource});

  List<SportEventModel> getEvents() => localDataSource.getEvents();

  SportEventModel? getCurrentEvent() => localDataSource.getCurrentEvent();

  List<SportEventModel> getArchivedEvents() => localDataSource.getArchivedEvents();

  void setCurrentEvent(String id) => localDataSource.setCurrentEvent(id);

  SportEventModel createNewEvent({
    required String name,
    required String description,
    required String block,
  }) {
    return localDataSource.createNewEvent(
      name: name,
      description: description,
      block: block,
    );
  }

  void updateEvent(SportEventModel event) => localDataSource.updateEvent(event);
}
