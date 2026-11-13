import 'package:material_ui/material_ui.dart';

import '../../../../core/constants/app_strings.dart';

/// Seite zur Konfiguration der Systemeinstellungen.
class SettingsPage extends StatelessWidget {
  /// Erstellt eine neue [SettingsPage].
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          AppStrings.settingsTitle,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
