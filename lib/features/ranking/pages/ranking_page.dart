import 'package:flutter/material.dart';

import '../../../core/navigation/app_routes.dart';
import '../../../core/widgets/app_layout.dart';

class RankingPage extends StatelessWidget {
  const RankingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      currentRoute: AppRoute.ranking,
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
