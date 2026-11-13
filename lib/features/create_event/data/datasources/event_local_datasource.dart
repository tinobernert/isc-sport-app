import '../../domain/models/sport_event_model.dart';

/// Lokale Datenquelle für Sportveranstaltungen.
abstract class EventLocalDataSource {
  List<SportEventModel> getEvents();
  SportEventModel? getCurrentEvent();
  List<SportEventModel> getArchivedEvents();
  void setCurrentEvent(int id);
  SportEventModel createNewEvent({
    required String name,
    required String description,
    required String block,
  });
  void updateEvent(SportEventModel event);
}

/// In-Memory-Implementierung der lokalen Datenquelle.
class EventLocalDataSourceImpl implements EventLocalDataSource {
  final List<SportEventModel> _events = [
    SportEventModel(
      id: 9,
      name: 'Sportfest Sommer 2025',
      description: 'Sommer-Bundesjugendspiele',
      block: 'A',
      date: DateTime(2025, 6, 15),
      isCurrent: true,
    ),
    SportEventModel(
      id: 8,
      name: 'Sporttag 2024 (Herbst)',
      description: 'Herbst-Leichtathletik-Wettkampf der Berufsschule.',
      block: 'B',
      date: DateTime(2024, 10, 12),
      isCurrent: false,
    ),
    SportEventModel(
      id: 7,
      name: 'Sportfest 2024 (Frühling)',
      description: 'Traditionelles Frühlings-Sportfest mit Disziplinen Lauf, Sprung, Wurf.',
      block: 'C',
      date: DateTime(2024, 5, 20),
      isCurrent: false,
    ),
  ];

  @override
  List<SportEventModel> getEvents() => List.unmodifiable(_events);

  @override
  SportEventModel? getCurrentEvent() {
    try {
      return _events.firstWhere((e) => e.isCurrent);
    } catch (_) {
      return null;
    }
  }

  @override
  List<SportEventModel> getArchivedEvents() => _events.where((e) => !e.isCurrent).toList();

  @override
  void setCurrentEvent(int id) {
    for (var e in _events) {
      e.isCurrent = (e.id == id);
    }
  }

  @override
  SportEventModel createNewEvent({
    required String name,
    required String description,
    required String block,
  }) {
    for (var e in _events) {
      e.isCurrent = false;
    }

    final newEvent = SportEventModel(
      id: DateTime.now().millisecondsSinceEpoch,
      name: name,
      description: description,
      block: block,
      date: DateTime.now(),
      isCurrent: true,
    );

    _events.insert(0, newEvent);
    return newEvent;
  }

  @override
  void updateEvent(SportEventModel event) {
    final index = _events.indexWhere((e) => e.id == event.id);
    if (index != -1) {
      _events[index] = event;
    }
  }
}
