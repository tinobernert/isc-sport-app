import 'package:material_ui/material_ui.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/models/sport_event_model.dart';

/// Detailansicht eines archivierten Events mit Ergebnissen und Ranglisten.
class EventHistoryPage extends StatelessWidget {
  /// Das anzuzeigende archivierte Event.
  final SportEventModel event;

  /// Erstellt eine neue [EventHistoryPage].
  const EventHistoryPage({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final sortedResults = List.of(event.results)
      ..sort((a, b) => b.points.compareTo(a.points));

    return Scaffold(
      appBar: AppBar(
        title: Text(event.name),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // Event Header Card
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: AppColors.grey200,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Block ${event.block} • Archiviert',
                          style: const TextStyle(
                            color: AppColors.grey800,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${event.date.day}.${event.date.month}.${event.date.year}',
                        style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    event.name,
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    event.description,
                    style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.textMuted),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 28),

          // Ergebnisse & Medaillenspiegel
          Text(
            'Ergebnisse & Platzierungen',
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          sortedResults.isEmpty
              ? const Center(child: Text('Keine Ergebnisse für dieses Event vorhanden.'))
              : Column(
                  children: sortedResults.asMap().entries.map((entry) {
                    final rank = entry.key + 1;
                    final student = entry.value;

                    Color? rankColor;
                    IconData rankIcon = Icons.military_tech;

                    if (rank == 1) {
                      rankColor = AppColors.gold;
                    } else if (rank == 2) {
                      rankColor = AppColors.silver;
                    } else if (rank == 3) {
                      rankColor = AppColors.bronze;
                    }

                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      elevation: 1,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: rankColor ?? colorScheme.primaryContainer,
                          child: rankColor != null
                              ? Icon(rankIcon, color: Colors.white)
                              : Text(
                                  '$rank',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.onPrimaryContainer,
                                  ),
                                ),
                        ),
                        title: Text(
                          student.studentName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'Klasse ${student.className}',
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade800),
                        ),
                        trailing: Text(
                          '${student.points} Pkt.',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: colorScheme.primary,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
        ],
      ),
    );
  }
}
