import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/models/sport_event_model.dart';
import '../../../core/services/sport_event_store.dart';
import '../../../core/theme/app_colors.dart';
import 'event_history_page.dart';
import 'show_event_page.dart';

/// Seite zum Erstellen und Verwalten von Sportveranstaltungen.
class CreateEventPage extends StatefulWidget {
  /// Erstellt eine neue [CreateEventPage].
  const CreateEventPage({super.key});

  @override
  State<CreateEventPage> createState() => _CreateEventPageState();
}

class _CreateEventPageState extends State<CreateEventPage> {
  final SportEventStore _store = SportEventStore();

  @override
  void initState() {
    super.initState();
    _store.addListener(_onStoreChanged);
  }

  @override
  void dispose() {
    _store.removeListener(_onStoreChanged);
    super.dispose();
  }

  void _onStoreChanged() {
    if (mounted) setState(() {});
  }

  void _createNewEvent(BuildContext context) {
    final newEvent = _store.createNewEvent(
      name: 'Sporttag 2026',
      description: '',
      block: 'A',
    );
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ShowEventPage(event: newEvent),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final current = _store.currentEvent;
    final archived = _store.archivedEvents;

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _createNewEvent(context),
        icon: const Icon(Icons.add, size: 18),
        label: const Text('Neues Event', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // 1. AKTUELLES EVENT Header
          Text(
            'AKTUELLES EVENT',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 8),

          // Orange accent line above the active event card matching the design reference
          Container(
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 12),

          // Aktuelles Event Card
          Card(
            color: AppColors.background,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: AppColors.grey300, width: 1.2),
            ),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ShowEventPage(event: current),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(16),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            current.name.isEmpty ? 'Unbenanntes Event' : current.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            current.description.isEmpty
                                ? 'Block ${current.block} • Keine Beschreibung hinterlegt'
                                : 'Block ${current.block} • ${current.description}',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textMuted,
                              height: 1.3,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'Event konfigurieren',
                      icon: const Icon(Icons.settings_outlined, color: AppColors.textMuted),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ShowEventPage(event: current),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 32),

          // 2. ARCHIVIERTE EVENTS Header
          Text(
            'ARCHIVIERTE EVENTS',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.textMuted,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 12),

          // Archivierte Events Liste
          archived.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text('Keine archivierten Events vorhanden.'),
                )
              : Column(
                  children: archived.map((archivedEvent) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Card(
                        color: AppColors.background,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(color: AppColors.grey300, width: 1.2),
                        ),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => EventHistoryPage(event: archivedEvent),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    color: AppColors.grey100,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Icon(Icons.history, color: AppColors.grey600, size: 20),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        archivedEvent.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        'Block ${archivedEvent.block} • ${archivedEvent.date.day}.${archivedEvent.date.month}.${archivedEvent.date.year}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppColors.textMuted,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const Icon(Icons.chevron_right, color: AppColors.grey500),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
          const SizedBox(height: 80),
        ],
      ),
    );
  }
}
