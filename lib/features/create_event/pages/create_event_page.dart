import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';

class CreateEventPage extends StatelessWidget {
  const CreateEventPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          AppStrings.createEventHeading,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ],
    );
  }
}
