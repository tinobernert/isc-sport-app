import 'package:flutter/material.dart';

import '../../../core/widgets/app_layout.dart';

class CreateEventPage extends StatelessWidget {
  const CreateEventPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: 'Veranstaltung erstellen',
      child: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            'Veranstaltung erstellen',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
        ],
      ),
    );
  }
}
