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

  void _showCreateEventDialog(BuildContext context) {
    final nameController = TextEditingController(text: 'Sporttag ${DateTime.now().year}');
    final descController = TextEditingController();
    String selectedBlock = 'A';

    showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            final theme = Theme.of(context);
            final colorScheme = theme.colorScheme;

            return AlertDialog(
              title: const Text('Neues Event anlegen'),
              content: SizedBox(
                width: 540,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Konfigurieren Sie das neue Sportfest für Ihre Berufsschulklassen.',
                        style: TextStyle(color: AppColors.textMuted),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: nameController,
                        decoration: const InputDecoration(
                          labelText: 'Name des Events',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.event_note),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: descController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Beschreibung (optional)',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.description),
                        ),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Block-Auswahl',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: ['A', 'B', 'C'].map((block) {
                          final isSelected = selectedBlock == block;
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: InkWell(
                                onTap: () {
                                  setDialogState(() {
                                    selectedBlock = block;
                                  });
                                },
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 14),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: isSelected ? colorScheme.primary : AppColors.grey100,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isSelected ? colorScheme.primary : AppColors.grey300,
                                    ),
                                  ),
                                  child: Text(
                                    'Block $block',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: isSelected ? Colors.white : AppColors.grey800,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  child: const Text('Abbrechen'),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: colorScheme.onPrimary,
                  ),
                  onPressed: () {
                    final newEvent = _store.createNewEvent(
                      name: nameController.text.trim().isEmpty ? 'Sporttag 2025' : nameController.text.trim(),
                      description: descController.text.trim(),
                      block: selectedBlock,
                    );
                    Navigator.pop(dialogContext);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ShowEventPage(event: newEvent),
                      ),
                    );
                  },
                  child: const Text('Event anlegen & Anzeigen'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final current = _store.currentEvent;
    final archived = _store.archivedEvents;

    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showCreateEventDialog(context),
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
                            current.name,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'Block ${current.block} • ${current.description}',
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
