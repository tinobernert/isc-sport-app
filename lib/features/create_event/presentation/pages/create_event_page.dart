import 'package:material_ui/material_ui.dart';

import '../../../../core/constants/app_strings.dart';
import '../../../../core/services/sport_event_store.dart';
import '../../../../core/theme/app_colors.dart';
import 'show_event_page.dart';

/// Seite zum Erstellen und Verwalten von Sportveranstaltungen (Presentation Layer).
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
        label: const Text(AppStrings.newEventButton, style: TextStyle(fontWeight: FontWeight.bold)),
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
            AppStrings.activeEventSectionHeader,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.primary,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 8),

          // Orange accent line above the active event card
          Container(
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 12),

          // Aktuelles Event Card
          if (current != null)
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
                            // Title & Badges Row (Aktiv, Block & Datum)
                            Wrap(
                              crossAxisAlignment: WrapCrossAlignment.center,
                              spacing: 10,
                              runSpacing: 6,
                              children: [
                                Text(
                                  current.name.isEmpty ? AppStrings.unnamedEvent : current.name,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black87,
                                  ),
                                ),
                                // Aktiv Badge
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.warningLight,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                                  ),
                                  child: const Text(
                                    AppStrings.activeStatusBadge,
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                // Block Badge
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE0F2FE),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    'Block ${current.block}',
                                    style: const TextStyle(
                                      color: Color(0xFF0369A1),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                // Datum Badge
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF1F5F9),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    '${current.date.day}.${current.date.month}.${current.date.year}',
                                    style: TextStyle(
                                      color: AppColors.grey800,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            // Description text
                            Text(
                              current.description.trim().isEmpty
                                  ? AppStrings.noDescriptionText
                                  : current.description,
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
            )
          else
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                AppStrings.noActiveEventText,
                style: TextStyle(color: AppColors.textMuted, fontSize: 14),
              ),
            ),

          const SizedBox(height: 32),

          // 2. ARCHIVIERTE EVENTS Header
          Text(
            AppStrings.archivedEventSectionHeader,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: AppColors.textMuted,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 12),

          // Archivierte Events Liste (volle Breite mit Badges)
          archived.isEmpty
              ? const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Text(AppStrings.noArchivedEventsText),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
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
                                builder: (context) => ShowEventPage(event: archivedEvent),
                              ),
                            );
                          },
                          borderRadius: BorderRadius.circular(16),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                            child: SizedBox(
                              width: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Wrap(
                                    crossAxisAlignment: WrapCrossAlignment.center,
                                    spacing: 10,
                                    runSpacing: 6,
                                    children: [
                                      Text(
                                        archivedEvent.name.isEmpty ? AppStrings.unnamedEvent : archivedEvent.name,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: Colors.black87,
                                        ),
                                      ),
                                      // Block Badge
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF1F5F9),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          'Block ${archivedEvent.block}',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.grey800,
                                          ),
                                        ),
                                      ),
                                      // Datum Badge
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF1F5F9),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          '${archivedEvent.date.day}.${archivedEvent.date.month}.${archivedEvent.date.year}',
                                          style: TextStyle(
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.grey800,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    archivedEvent.description.trim().isEmpty
                                        ? AppStrings.noDescriptionText
                                        : archivedEvent.description,
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: AppColors.textMuted,
                                    ),
                                  ),
                                ],
                              ),
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
