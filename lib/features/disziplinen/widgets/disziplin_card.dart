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
    final isHigher = discipline.higherIsBetter;
    final richtungText = isHigher ? 'Höher ist besser' : 'Niedriger ist besser';
    final richtungIcon = isHigher ? Icons.arrow_upward : Icons.arrow_downward;
    final richtungBg = isHigher ? Colors.green.shade50 : Colors.amber.shade50;
    final richtungColor = isHigher ? Colors.green.shade700 : Colors.amber.shade800;

    return Card(
      color: Colors.white,
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header: Icon + Name
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      discipline.icon,
                      color: AppColors.primary,
                      size: 18,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      discipline.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Badge: Richtung
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: richtungBg,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(richtungIcon, size: 11, color: richtungColor),
                    const SizedBox(width: 4),
                    Text(
                      richtungText,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        color: richtungColor,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Trennlinie oben im unteren Bereich
              const Divider(height: 1, color: Color(0xFFEEEEEE)),
              const SizedBox(height: 6),

              // Zeile 1: Einheit (Label links, Wert rechts)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Einheit',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  Text(
                    discipline.einheit,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade800,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 4),

              // Zeile 2: Gewichtung (Label links, Wert rechts)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Gewichtung',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  Text(
                    '${discipline.gewichtung} x',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}