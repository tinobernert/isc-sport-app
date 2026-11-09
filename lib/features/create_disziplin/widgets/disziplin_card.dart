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
      color: const Color.fromARGB(255, 255, 234, 221),
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
          padding: const EdgeInsets.all(8),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  disziplin.name,
                  textAlign: TextAlign.left,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w600),
                ),
                Text(
                  '${disziplin.einheit}, ${disziplin.richtung.name}, ${disziplin.gewichtung}',
                  textAlign: TextAlign.left,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium
                      ?.copyWith(fontWeight: FontWeight.w400, color: const Color.fromARGB(255, 147, 148, 148),),
                )
              ],)

          ),
        ),
      ),
    );
  }
}
