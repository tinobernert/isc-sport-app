import 'package:flutter/material.dart';

import '../../../core/widgets/app_layout.dart';

class ClassesPage extends StatelessWidget {
  const ClassesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: 'Klassen',
      selectedIndex: 4,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text('Klassen', style: Theme.of(context).textTheme.headlineMedium),
        ],
      ),
    );
  }
}
