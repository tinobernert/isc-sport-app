import 'package:flutter/foundation.dart';
import '../models/sport_event_model.dart';

class SportEventStore extends ChangeNotifier {
  static final SportEventStore _instance = SportEventStore._internal();
  factory SportEventStore() => _instance;
  SportEventStore._internal();

  final List<SportEventModel> _events = [
    SportEventModel(
      id: 'event_active_1',
      name: 'Sportfest Sommer 2025',
      description: 'Sommer-Bundesjugendspiele',
      block: 'A',
      date: DateTime(2025, 6, 15),
      isCurrent: true,
    ),
    SportEventModel(
      id: 'event_archived_1',
      name: 'Sporttag 2024 (Herbst)',
      description: 'Herbst-Leichtathletik-Wettkampf der Berufsschule.',
      block: 'B',
      date: DateTime(2024, 10, 12),
      isCurrent: false,
    ),
    SportEventModel(
      id: 'event_archived_2',
      name: 'Sportfest 2024 (Frühling)',
      description: 'Traditionelles Frühlings-Sportfest mit Disziplinen Lauf, Sprung, Wurf.',
      block: 'C',
      date: DateTime(2024, 5, 20),
      isCurrent: false,
    ),
  ];

  List<SportEventModel> get events => List.unmodifiable(_events);

  SportEventModel get currentEvent {
    try {
      return _events.firstWhere((e) => e.isCurrent);
    } catch (_) {
      return _events.first;
    }
  }

  List<SportEventModel> get archivedEvents => _events.where((e) => !e.isCurrent).toList();

  void setCurrentEvent(String id) {
    for (var e in _events) {
      e.isCurrent = (e.id == id);
    }
    notifyListeners();
  }

  SportEventModel createNewEvent({
    required String name,
    required String description,
    required String block,
  }) {
    // Demote current event if any
    for (var e in _events) {
      e.isCurrent = false;
    }

    final newEvent = SportEventModel(
      id: 'event_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      description: description,
      block: block,
      date: DateTime.now(),
      isCurrent: true,
    );

    _events.insert(0, newEvent);
    notifyListeners();
    return newEvent;
  }

  void updateEvent(SportEventModel updatedEvent) {
    final index = _events.indexWhere((e) => e.id == updatedEvent.id);
    if (index != -1) {
      _events[index] = updatedEvent;
      notifyListeners();
    }
  }
}
