import 'package:flutter/material.dart';

import '../../../core/navigation/app_routes.dart';
import '../../../core/widgets/app_layout.dart';

/// Seite zur Konfiguration der Systemeinstellungen.
class SettingsPage extends StatelessWidget {
  /// Erstellt eine neue [SettingsPage].
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      currentRoute: AppRoute.settings,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            AppRoute.settings.title,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
