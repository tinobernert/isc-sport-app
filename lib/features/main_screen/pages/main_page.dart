import 'package:flutter/material.dart';

import '../../../core/widgets/app_layout.dart';

class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: 'Hauptseite',
      selectedIndex: 0,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text('Hauptseite', style: Theme.of(context).textTheme.headlineMedium),
        ],
      ),
    );
  }
}
