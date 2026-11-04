import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';

class DisziplinPage extends StatelessWidget {
  const DisziplinPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Text(
          AppStrings.disziplinenTitle,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ],
    );
  }
}
