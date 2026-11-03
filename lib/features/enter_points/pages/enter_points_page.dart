import 'package:flutter/material.dart';

class EnterPointsPage extends StatelessWidget {
  const EnterPointsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          'Punkteeingabe',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ],
    );
  }
}
