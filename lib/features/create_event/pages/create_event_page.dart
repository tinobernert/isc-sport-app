import 'package:flutter/material.dart';

class CreateEventPage extends StatelessWidget {
  const CreateEventPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          'Veranstaltung erstellen',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ],
    );
  }
}
