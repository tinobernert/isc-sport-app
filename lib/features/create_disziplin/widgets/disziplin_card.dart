import 'package:flutter/material.dart';

import '../models/disziplinen.dart';

// Vorlage für eine einzelne Disziplin. Hier kannst du das Design anpassen.
class DisziplinCard extends StatelessWidget {
  final Disziplinen disziplin;
  final VoidCallback onTap;

  const DisziplinCard({
    super.key,
    required this.disziplin,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Text(
              disziplin.name,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ),
    );
  }
}
