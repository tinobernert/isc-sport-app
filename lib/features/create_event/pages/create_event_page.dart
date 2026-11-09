import 'package:flutter/material.dart';

import '../../../core/navigation/app_routes.dart';
import '../../../core/widgets/app_layout.dart';

/// Seite zum Erstellen einer neuen Sportveranstaltung.
class CreateEventPage extends StatelessWidget {
  /// Erstellt eine neue [CreateEventPage].
  const CreateEventPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      currentRoute: AppRoute.createEvent,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            AppRoute.createEvent.title,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ],
      ),
    );
  }
}
