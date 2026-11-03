import 'package:flutter/material.dart';

import '../../features/classes/pages/classes_page.dart';
import '../../features/create_disziplin/pages/disziplin_page.dart';
import '../../features/enter_points/pages/enter_points_page.dart';
import '../../features/main_screen/pages/main_page.dart';
import '../../features/ranking/pages/ranking_page.dart';
import '../../features/settings/pages/settings_page.dart';

/// AppRoute repräsentiert alle Haupt-Navigationsziele in der App
/// inkl. Titel, Icons und der Verknüpfung zur entsprechenden Seite.
enum AppRoute {
  mainPage(
    title: 'Hauptseite',
    icon: Icon(Icons.home_outlined),
    selectedIcon: Icon(Icons.home),
  ),
  ranking(
    title: 'Punkteauswertung111',
    icon: Icon(Icons.bar_chart_outlined),
    selectedIcon: Icon(Icons.bar_chart),
  ),
  enterPoints(
    title: 'Punkteeingabe',
    icon: Icon(Icons.edit_note),
    selectedIcon: Icon(Icons.edit_note),
  ),
  disziplinen(
    title: 'Disziplinen',
    icon: Icon(Icons.sports),
    selectedIcon: Icon(Icons.sports),
  ),
  classes(
    title: 'Klassen',
    icon: Icon(Icons.groups_outlined),
    selectedIcon: Icon(Icons.groups),
  ),
  settings(
    title: 'Einstellungen',
    icon: Icon(Icons.settings_outlined),
    selectedIcon: Icon(Icons.settings),
    isFooter: true,
  );

  final String title;
  final Widget icon;
  final Widget? selectedIcon;
  final bool isFooter;

  const AppRoute({
    required this.title,
    required this.icon,
    this.selectedIcon,
    this.isFooter = false,
  });

  /// Baut die zugehörige Page auf.
  Widget buildPage() {
    switch (this) {
      case AppRoute.mainPage:
        return const MainPage();
      case AppRoute.ranking:
        return const RankingPage();
      case AppRoute.enterPoints:
        return const EnterPointsPage();
      case AppRoute.disziplinen:
        return const DisziplinPage();
      case AppRoute.classes:
        return const ClassesPage();
      case AppRoute.settings:
        return const SettingsPage();
    }
  }
}

class AppRoutes {
  /// Navigiert zum Ziel-Route Enum.
  static void navigateTo(
    BuildContext context,
    AppRoute targetRoute,
    AppRoute? currentRoute,
  ) {
    Navigator.pop(context); // Sidebar schliessen.
    if (targetRoute == currentRoute) return;

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            targetRoute.buildPage(),
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }

  /// Navigiert basierend auf dem Index (z. B. vom SideBar Drawer).
  static void navigateByIndex(
    BuildContext context,
    int index,
    AppRoute? currentRoute,
  ) {
    if (index < 0 || index >= AppRoute.values.length) return;
    navigateTo(context, AppRoute.values[index], currentRoute);
  }
}
