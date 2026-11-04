import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';

class EnterPointsPage extends StatelessWidget {
  const EnterPointsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          AppStrings.enterPointsTitle,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ],
    );
  }
}
