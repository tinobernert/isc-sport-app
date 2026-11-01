import 'package:flutter/material.dart';

import '../../../core/widgets/app_layout.dart';

class EnterPointsPage extends StatelessWidget {
  const EnterPointsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: 'Punkteeingabe',
      selectedIndex: 2,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            'Punkteeingabe',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ],
      ),
    );
  }
}
