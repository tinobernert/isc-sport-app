import 'package:flutter/material.dart';
import '../../../core/models/sport_event_model.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/theme/app_colors.dart';

/// Seite zur Anzeige der Bestenliste und Details eines archivierten Events.
class EventHistoryPage extends StatelessWidget {
  /// Das anzuzeigende [SportEventModel].
  final SportEventModel event;

  /// Erstellt eine neue [EventHistoryPage].
  const EventHistoryPage({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text('Bestenliste: ${event.name}'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // Event Info Header Card
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
                          color: colorScheme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Block ${event.block}',
                          style: TextStyle(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Datum: ${event.date.day}.${event.date.month}.${event.date.year}',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.textMuted,
                        ),
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
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            AppStrings.rankingHeading,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),
          // Student Results List
          ...event.results.map((result) {
            Color? rankColor;
            IconData? rankIcon;
            if (result.rank == 1) {
              rankColor = AppColors.gold;
              rankIcon = Icons.military_tech;
            } else if (result.rank == 2) {
              rankColor = AppColors.silver;
              rankIcon = Icons.military_tech;
            } else if (result.rank == 3) {
              rankColor = AppColors.bronze;
              rankIcon = Icons.military_tech;
            }

            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              elevation: 1,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                leading: CircleAvatar(
                  backgroundColor: rankColor ?? colorScheme.primary.withValues(alpha: 0.1),
                  child: rankIcon != null
                      ? Icon(rankIcon, color: Colors.white)
                      : Text(
                          '#${result.rank}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: rankColor != null ? Colors.white : colorScheme.primary,
                          ),
                        ),
                ),
                title: Row(
                  children: [
                    Text(
                      result.studentName,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        result.className,
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade800),
                      ),
                    ),
                  ],
                ),
                subtitle: Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    'Disziplin: ${result.disciplineName} • Leistung: ${result.performance}',
                    style: const TextStyle(color: AppColors.textMuted, fontSize: 13),
                  ),
                ),
                trailing: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${result.points} Pkt',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
