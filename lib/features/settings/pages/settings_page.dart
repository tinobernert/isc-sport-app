import 'package:flutter/material.dart';

import '../../../core/widgets/app_layout.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: 'Einstellungen',
      selectedIndex: 5,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            'Einstellungen',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
