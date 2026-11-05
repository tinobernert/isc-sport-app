import 'package:flutter/material.dart';

class SideBar extends StatelessWidget {
  final int? selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  const SideBar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return NavigationDrawer(
      backgroundColor: const Color.fromARGB(255, 255, 234, 221),
      indicatorColor: const Color.fromARGB(255, 255, 142, 72),
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 28, 16, 16),
          child: Row(
            children: [
              const CircleAvatar(radius: 26, child: Text('SP')),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'SportPoint',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Sportverwaltung',
                    style: TextStyle(color: scheme.onSurfaceVariant),
                  ),
                ],
              ),
            ],
          ),
        ),
        const Divider(),

        const NavigationDrawerDestination(
          icon: Icon(Icons.bar_chart_outlined),
          label: Text('Hauptseite'),
        ),
        const NavigationDrawerDestination(
          icon: Icon(Icons.bar_chart_outlined),
          label: Text('Punkteauswertung'),
        ),
        const NavigationDrawerDestination(
          icon: Icon(Icons.edit_note),
          label: Text('Punkteeingabe'),
        ),
        const NavigationDrawerDestination(
          icon: Icon(Icons.sports),
          label: Text('Disziplinen'),
        ),
        const NavigationDrawerDestination(
          icon: Icon(Icons.groups_outlined),
          label: Text('Klassen'),
        ),

        const Padding(
          padding: EdgeInsets.fromLTRB(28, 16, 28, 8),
          child: Divider(),
        ),

        const NavigationDrawerDestination(
          icon: Icon(Icons.settings_outlined),
          label: Text('Einstellungen'),
        ),
      ],
    );
  }
}
