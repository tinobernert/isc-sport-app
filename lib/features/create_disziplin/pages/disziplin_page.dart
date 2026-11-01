import 'package:flutter/material.dart';

import '../../../core/widgets/app_layout.dart';

class DisziplinPage extends StatelessWidget {
  const DisziplinPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: 'Disziplinen',
      selectedIndex: 3,
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            'Disziplinen',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ],
      ),
    );
  }
}
