import 'package:flutter/foundation.dart';
import '../../features/create_event/domain/models/sport_event_model.dart';

class SportEventStore extends ChangeNotifier {
  static final SportEventStore _instance = SportEventStore._internal();
  factory SportEventStore() => _instance;
  SportEventStore._internal();

  final List<SportEventModel> _events = [
    SportEventModel(
      id: 9,
      name: 'Sportfest 2026',
      description: 'Sportfest Block B',
      block: 'B',
      date: DateTime(2025, 6, 15),
      isCurrent: true,
    ),
    SportEventModel(
      id: 8,
      name: 'Sportfest 2026',
      description: 'Sportfest Block A',
      block: 'A',
      date: DateTime(2025, 6, 15),
      isCurrent: false,
    ),
    SportEventModel(
      id: 7,
      name: 'Sporttag 2025',
      description: 'Sportfest Block C',
      block: 'C',
      date: DateTime(2024, 10, 12),
      isCurrent: false,
    ),
    SportEventModel(
      id: 6,
      name: 'Sportfest 2025',
      description: 'Sportfest Block B',
      block: 'B',
      date: DateTime(2024, 5, 20),
      isCurrent: false,
    ),
  ];

  List<SportEventModel> get events => List.unmodifiable(_events);

  /// Gibt das aktuell aktive Event zurück oder `null`, falls kein Event als aktiv markiert ist.
  SportEventModel? get currentEvent {
    try {
      return _events.firstWhere((e) => e.isCurrent);
    } catch (_) {
      return null;
    }
  }

  /// Gibt alle nicht-aktiven (archivierten) Events zurück.
  List<SportEventModel> get archivedEvents => _events.where((e) => !e.isCurrent).toList();

  /// Markiert das Event mit [id] als einziges aktives Event.
  void setCurrentEvent(int id) {
    for (var e in _events) {
      e.id == id ? e.isCurrent = true : e.isCurrent = false;
    }
    notifyListeners();
  }

  /// Erstellt ein neues Event und setzt es als aktives Event.
  SportEventModel createNewEvent({
    required String name,
    required String description,
    required String block,
  }) {
    // Alle anderen Events deaktivieren
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
    notifyListeners();
    return newEvent;
  }

  /// Aktualisiert ein bestehendes Event.
  void updateEvent(SportEventModel updatedEvent) {
    final index = _events.indexWhere((e) => e.id == updatedEvent.id);
    if (index != -1) {
      _events[index] = updatedEvent;
      notifyListeners();
    }
  }
}
