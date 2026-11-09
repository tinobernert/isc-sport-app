import 'package:flutter/material.dart';

import '../../../core/navigation/app_routes.dart';
import '../../../core/widgets/app_layout.dart';

/// Die Hauptübersichtsseite (Dashboard) der Anwendung.
class MainPage extends StatelessWidget {
  /// Erstellt eine neue [MainPage].
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      currentRoute: AppRoute.mainPage,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            AppRoute.mainPage.title,
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ],
      ),
    );
  }
}
