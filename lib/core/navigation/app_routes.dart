import 'package:flutter/material.dart';

import '../../features/classes/pages/classes_page.dart';
import '../../features/create_event/pages/create_event_page.dart';
import '../../features/disziplinen/pages/disziplin_page.dart';
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
    title: 'Punkteauswertung',
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
  createEvent(
    title: 'Veranstaltung erstellen',
    icon: Icon(Icons.event_outlined),
    selectedIcon: Icon(Icons.event),
  ),
  settings(
    title: 'Einstellungen',
    icon: Icon(Icons.settings_outlined),
    selectedIcon: Icon(Icons.settings),
    isFooter: true,
  );

  /// Der in der Navigation/AppBar angezeigte Titel.
  final String title;

  /// Das Icon im inaktiven Zustand.
  final Widget icon;

  /// Das Icon im ausgewählten Zustand.
  final Widget? selectedIcon;

  /// Gibt an, ob das Element unten im Footer des Drawers gerendert wird.
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
      case AppRoute.createEvent:
        return const CreateEventPage();
      case AppRoute.settings:
        return const SettingsPage();
    }
  }
}

/// Hilfsklasse zur Steuerung der Bildschirmnavigation.
class AppRoutes {
  /// Navigiert zum Ziel-Route Enum.
  static void navigateTo(
    BuildContext context,
    AppRoute targetRoute,
    AppRoute? currentRoute,
  ) {
    // Drawer nur schließen, falls dieser aktuell geöffnet ist.
    if (Scaffold.maybeOf(context)?.isDrawerOpen ?? false) {
      Navigator.pop(context);
    }
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
