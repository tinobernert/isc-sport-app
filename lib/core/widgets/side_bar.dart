import 'package:flutter/material.dart';

import '../navigation/app_routes.dart';

class SideBar extends StatelessWidget {
  final AppRoute? currentRoute;
  final ValueChanged<AppRoute> onRouteSelected;

  const SideBar({
    super.key,
    required this.currentRoute,
    required this.onRouteSelected,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final mainRoutes = AppRoute.values.where((r) => !r.isFooter).toList();
    final footerRoutes = AppRoute.values.where((r) => r.isFooter).toList();

    return NavigationDrawer(
      selectedIndex: currentRoute?.index,
      onDestinationSelected: (index) {
        if (index >= 0 && index < AppRoute.values.length) {
          onRouteSelected(AppRoute.values[index]);
        }
      },
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

        ...mainRoutes.map(
          (route) => NavigationDrawerDestination(
            icon: route.icon,
            selectedIcon: route.selectedIcon,
            label: Text(route.title),
          ),
        ),

        const Padding(
          padding: EdgeInsets.fromLTRB(28, 16, 28, 8),
          child: Divider(),
        ),

        ...footerRoutes.map(
          (route) => NavigationDrawerDestination(
            icon: route.icon,
            selectedIcon: route.selectedIcon,
            label: Text(route.title),
          ),
        ),
      ],
    );
  }
}
