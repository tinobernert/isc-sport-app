import 'package:material_ui/material_ui.dart';

import '../../../../core/constants/app_strings.dart';

/// Seite zur Eingabe von erzielten Punkten und Leistungen.
class EnterPointsPage extends StatelessWidget {
  /// Erstellt eine neue [EnterPointsPage].
  const EnterPointsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          AppStrings.enterPointsTitle,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ],
    );
  }
}
