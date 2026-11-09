import 'package:flutter/material.dart';

import '../../../core/navigation/app_routes.dart';
import '../../../core/widgets/app_layout.dart';

/// Seite zur Anzeige der Punktauswertung und Ranglisten.
class RankingPage extends StatelessWidget {
  /// Erstellt eine neue [RankingPage].
  const RankingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      currentRoute: AppRoute.ranking,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            AppRoute.ranking.title,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
