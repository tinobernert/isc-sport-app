import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';

import '../../../core/navigation/app_routes.dart';

/// Seite zur Anzeige der Punktauswertung und Ranglisten.
class RankingPage extends StatelessWidget {
  /// Erstellt eine neue [RankingPage].
  const RankingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          AppStrings.rankingHeading,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 10),
      ],
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          AppRoute.ranking.title,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
