import 'package:material_ui/material_ui.dart';
import '../../../../core/theme/app_colors.dart';

/// Ein Dialog zur Auswahl eines Icons aus einer umfangreichen Liste von Sport- und allgemeinen Icons.
class IconPickerDialog extends StatelessWidget {
  /// Das aktuell ausgewählte Icon.
  final IconData selectedIcon;

  /// Erstellt einen neuen [IconPickerDialog].
  const IconPickerDialog({super.key, required this.selectedIcon});

  /// Liste der verfügbaren Icons.
  static const List<IconData> allIcons = [
    Icons.directions_run,
    Icons.height,
    Icons.fitness_center,
    Icons.timer,
    Icons.airline_seat_legroom_extra,
    Icons.sports_kabaddi,
    Icons.speed,
    Icons.sports_baseball,
    Icons.sports,
    Icons.sports_basketball,
    Icons.sports_soccer,
    Icons.sports_tennis,
    Icons.sports_volleyball,
    Icons.pool,
    Icons.bolt,
    Icons.military_tech,
    Icons.emoji_events,
    Icons.flag,
    Icons.directions_walk,
    Icons.directions_bike,
    Icons.directions_boat,
    Icons.rowing,
    Icons.golf_course,
    Icons.snowboarding,
    Icons.surfing,
    Icons.skateboarding,
    Icons.local_fire_department,
    Icons.star,
    Icons.favorite,
    Icons.flash_on,
    Icons.shield,
    Icons.workspace_premium,
    Icons.timer_outlined,
    Icons.bar_chart,
    Icons.show_chart,
    Icons.assessment,
    Icons.task_alt,
    Icons.check_circle_outline,
    Icons.timer_3,
    Icons.sports_score,
    Icons.sports_martial_arts,
    Icons.sports_mma,
    Icons.sports_motorsports,
    Icons.sports_handball,
    Icons.sports_hockey,
    Icons.sports_rugby,
    Icons.sports_cricket,
  ];

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Icon auswählen'),
      content: SizedBox(
        width: 400,
        height: 350,
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 6,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemCount: allIcons.length,
          itemBuilder: (context, index) {
            final icon = allIcons[index];
            final isSelected = icon == selectedIcon;
            return InkWell(
              onTap: () => Navigator.pop(context, icon),
              borderRadius: BorderRadius.circular(12),
              child: Container(
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primaryLight : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : Colors.grey.shade300,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: Icon(
                  icon,
                  color: isSelected ? AppColors.primary : Colors.grey.shade700,
                  size: 24,
                ),
              ),
            );
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Abbrechen'),
        ),
      ],
    );
  }
}
