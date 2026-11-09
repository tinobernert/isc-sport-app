import 'package:flutter/material.dart';

/// Eine einheitliche Seitenüberschrift für Screens.
class PageHeading extends StatelessWidget {
  /// Der Titel der Seite.
  final String title;

  /// Erstellt eine neue [PageHeading].
  const PageHeading({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
