import 'package:flutter/material.dart';

import '../../../core/widgets/app_layout.dart';

class RankingPage extends StatelessWidget {
  const RankingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: 'Punkteauswertung',
      selectedIndex: 1,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text('Rangliste', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
