import 'dart:async';
import 'package:flutter/material.dart';
import '../../features/event/domain/models/event_item.dart';

class AppSettings extends ChangeNotifier {
  static final AppSettings _instance = AppSettings._internal();
  factory AppSettings() => _instance;
  AppSettings._internal();

  String _selectedBlockConfig = 'ALL';
  bool _isSyncing = false;

  bool _isAdminMode = false;
  final String _adminPassword = 'admin';

  // EVENT-VERWALTUNG
  bool _isEventActive = true;
  String _activeEventCode = 'Sportfest 2026 - Block B';

  EventItem _activeEvent = EventItem(
    id: 1,
    title: 'Sportfest 2026 - Block B',
    description: 'Haupt-Sporttag der Jahrgänge 24, 25 und 26',
    block: 'B',
    date: DateTime(2026, 6, 18),
  );

  final List<EventItem> _eventHistory = [
    EventItem(
      id: 2,
      title: 'Sportfest 2025 - Block A',
      description: 'Sportfest des vergangenen Schuljahres',
      block: 'A',
      date: DateTime(2025, 6, 15),
    ),
    EventItem(
      id: 3,
      title: 'Herbst-Sporttag 2025',
      description: 'Zusatz-Sporttag der IT-Klassen',
      block: 'C',
      date: DateTime(2025, 9, 20),
    ),
  ];

  // ADMIN-TOOLS TIMER (3 MINUTEN = 180 SEKUNDEN)
  bool _adminToolsActive = false;
  Timer? _adminToolsTimer;
  int _adminRemainingSeconds = 0;

  String get selectedBlockConfig => _selectedBlockConfig;
  bool get isSyncing => _isSyncing;
  bool get isAdminMode => _isAdminMode;

  bool get adminToolsActive => _adminToolsActive;
  bool get canDeleteItems => _adminToolsActive;
  bool get canCreateEvent => _adminToolsActive;
  int get adminRemainingSeconds => _adminRemainingSeconds;
  int get remainingSeconds => _adminRemainingSeconds;

  bool get isEventActive => _isEventActive;
  String get activeEventCode => _activeEventCode;
  EventItem get activeEvent => _activeEvent;
  List<EventItem> get eventHistory => _eventHistory;

  void setBlockConfig(String block) {
    _selectedBlockConfig = block;
    notifyListeners();
  }

  void setActiveEventCode(String code) {
    _activeEventCode = code;
    notifyListeners();
  }

  void setEventActive(bool active) {
    _isEventActive = active;
    notifyListeners();
  }

  void addLocalEvent(EventItem newEvent) {
    _eventHistory.insert(0, _activeEvent);
    _activeEvent = newEvent;
    _activeEventCode = newEvent.title;
    _selectedBlockConfig = newEvent.block;
    notifyListeners();
  }

  void removeHistoryEvent(EventItem event) {
    _eventHistory.removeWhere((e) => e.id == event.id);
    notifyListeners();
  }

  bool unlockAdminMode(String password) {
    if (password == _adminPassword) {
      _isAdminMode = true;
      enableAdminToolsFor3Minutes();
      notifyListeners();
      return true;
    }
    return false;
  }

  void lockAdminMode() {
    _isAdminMode = false;
    disableAdminToolsManually();
    notifyListeners();
  }

  void enableAdminToolsFor3Minutes() {
    _adminToolsActive = true;
    _adminRemainingSeconds = 180;
    _adminToolsTimer?.cancel();
    notifyListeners();

    _adminToolsTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_adminRemainingSeconds > 1) {
        _adminRemainingSeconds--;
        notifyListeners();
      } else {
        disableAdminToolsManually();
      }
    });
  }

  void enableDeletionFor3Minutes() => enableAdminToolsFor3Minutes();

  void disableAdminToolsManually() {
    _adminToolsTimer?.cancel();
    _adminToolsActive = false;
    _adminRemainingSeconds = 0;
    notifyListeners();
  }

  void disableDeletionManually() => disableAdminToolsManually();

  Future<void> syncWithServer() async {
    _isSyncing = true;
    notifyListeners();

    await Future.delayed(const Duration(seconds: 2));

    disableAdminToolsManually();

    _activeEvent = EventItem(
      id: 1,
      title: 'Sportfest 2026 - Block B',
      description: 'Haupt-Sporttag der Jahrgänge 24, 25 und 26',
      block: 'B',
      date: DateTime(2026, 6, 18),
      isLocalOnly: false,
    );

    _eventHistory.clear();
    _eventHistory.addAll([
      EventItem(
        id: 2,
        title: 'Sportfest 2025 - Block A',
        description: 'Sportfest des vergangenen Schuljahres',
        block: 'A',
        date: DateTime(2025, 6, 15),
        isLocalOnly: false,
      ),
      EventItem(
        id: 3,
        title: 'Herbst-Sporttag 2025',
        description: 'Zusatz-Sporttag der IT-Klassen',
        block: 'C',
        date: DateTime(2025, 9, 20),
        isLocalOnly: false,
      ),
    ]);

    _activeEventCode = _activeEvent.title;
    _isEventActive = true;
    _selectedBlockConfig = 'B';

    _isSyncing = false;
    notifyListeners();
  }
}
