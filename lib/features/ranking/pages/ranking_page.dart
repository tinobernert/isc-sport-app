import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';

class RankingPage extends StatelessWidget {
  const RankingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          AppStrings.rankingHeading,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
