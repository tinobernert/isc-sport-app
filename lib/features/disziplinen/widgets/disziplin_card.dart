import 'package:material_ui/material_ui.dart';

import '../../../core/theme/app_colors.dart';
import '../models/disziplin.dart';

/// Card-Widget zur Anzeige einer einzelnen Disziplin in der Übersicht.
class DisziplinCard extends StatelessWidget {
  /// Die anzuzeigende Disziplin.
  final Disziplin disziplin;

  /// Callback beim Antippen der Karte (z. B. zum Bearbeiten).
  final VoidCallback onTap;

  /// Erstellt eine neue [DisziplinCard].
  const DisziplinCard({
    super.key,
    required this.disziplin,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
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
                  disziplin.name,
                  textAlign: TextAlign.left,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Text(
                  '${disziplin.einheit}, ${disziplin.richtung.name}, ${disziplin.gewichtung}',
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
