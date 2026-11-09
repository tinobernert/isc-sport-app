import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';

/// Seite zur Verwaltung von Schulklassen und Teilnehmergruppen.
class ClassesPage extends StatelessWidget {
  /// Erstellt eine neue [ClassesPage].
  const ClassesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          AppStrings.classesTitle,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ],
    );
  }
}
