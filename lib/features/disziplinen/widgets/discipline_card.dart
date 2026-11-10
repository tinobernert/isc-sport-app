import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/models/discipline_model.dart';

/// Card-Widget zur Anzeige einer einzelnen Disziplin in der Übersicht.
class DisciplineCard extends StatelessWidget {
  /// Die anzuzeigende Disziplin.
  final DisciplineModel discipline;

  /// Callback beim Antippen der Karte (z. B. zum Bearbeiten).
  final VoidCallback onTap;

  /// Erstellt eine neue [DisciplineCard].
  const DisciplineCard({
    super.key,
    required this.discipline,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isHigher = discipline.higherIsBetter;
    final directionText = isHigher ? 'Höher ist besser' : 'Niedriger ist besser';
    final directionIcon = isHigher ? Icons.arrow_upward : Icons.arrow_downward;
    final directionBg = isHigher ? AppColors.successLight : AppColors.warningLight;
    final directionColor = isHigher ? AppColors.successDark : AppColors.warningDark;

    return Card(
      color: AppColors.background,
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: AppColors.grey200),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row: Icon & Title
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

              // Statischer Beschreibungstext als Platzhalter
              Text(
                'Klassische Durchführung dieser Disziplin gemäß den regulären Vorgaben.',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11,
                  height: 1.3,
                  color: AppColors.grey600,
                ),
              ),

              const SizedBox(height: 8),

              // Badge (Höher/Niedriger ist besser)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: directionBg,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(directionIcon, size: 11, color: directionColor),
                    const SizedBox(width: 4),
                    Text(
                      directionText,
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: directionColor,
                      ),
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Trennlinie
              const Divider(height: 16, color: Color(0xFFF0F0F0)),

              // Zeile: Einheit
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Einheit',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.grey500,
                    ),
                  ),
                  Text(
                    discipline.unit,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.grey800,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 4),

              // Zeile: Gewichtung
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Gewichtung',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.grey500,
                    ),
                  ),
                  Text(
                    '${discipline.weight} x',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: AppColors.grey800,
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
