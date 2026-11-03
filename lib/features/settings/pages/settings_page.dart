import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          'Einstellungen',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
