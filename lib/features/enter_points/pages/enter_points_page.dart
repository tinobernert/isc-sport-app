import 'package:flutter/material.dart';

import '../../../core/navigation/app_routes.dart';
import '../../../core/widgets/app_layout.dart';

/// Seite zur Eingabe von erzielten Punkten und Leistungen.
class EnterPointsPage extends StatelessWidget {
  /// Erstellt eine neue [EnterPointsPage].
  const EnterPointsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      currentRoute: AppRoute.enterPoints,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            AppRoute.enterPoints.title,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ],
      ),
    );
  }
}
