import 'package:flutter/material.dart';

class DisziplinPage extends StatelessWidget {
  const DisziplinPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          'Disziplinen',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ],
    );
  }
}
