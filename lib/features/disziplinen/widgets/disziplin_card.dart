import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/models/discipline_model.dart';

/// Card-Widget zur Anzeige einer einzelnen Disziplin in der Übersicht.
class DisziplinCard extends StatelessWidget {
  /// Die anzuzeigende Disziplin.
  final DisciplineModel discipline;

  /// Callback beim Antippen der Karte (z. B. zum Bearbeiten).
  final VoidCallback onTap;

  /// Erstellt eine neue [DisziplinCard].
  const DisziplinCard({
    super.key,
    required this.discipline,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final richtungText = discipline.higherIsBetter ? 'Höher ist besser' : 'Niedriger ist besser';

    return Card(
      color: AppColors.primaryLight,
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  discipline.name,
                  textAlign: TextAlign.left,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Text(
                  '${discipline.einheit} • $richtungText • Gew: ${discipline.gewichtung}',
                  textAlign: TextAlign.left,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w400,
                        color: AppColors.textMuted,
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
