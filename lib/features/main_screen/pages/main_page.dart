import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';

/// Die Hauptübersichtsseite (Dashboard) der Anwendung.
class MainPage extends StatelessWidget {
  /// Erstellt eine neue [MainPage].
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          AppStrings.mainPageTitle,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ],
    );
  }
}
