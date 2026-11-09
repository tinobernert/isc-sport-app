import 'package:flutter/material.dart';

import '../navigation/app_routes.dart';
import 'main_app_bar.dart';
import 'side_bar.dart';

/// Das grundlegende Layout-Scaffold für Hauptseiten mit AppBar und SideBar.
class AppLayout extends StatelessWidget {
  /// Erstellt ein neues [AppLayout].
  const AppLayout({
    super.key,
    this.currentRoute,
    this.title,
    required this.child,
  });

  /// Die aktuell aktive Route.
  final AppRoute? currentRoute;

  /// Optionaler spezifischer Titel. Falls `null`, wird der Titel der [currentRoute] verwendet.
  final String? title;

  /// Das Inhaltselement der Seite.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final displayTitle = title ?? currentRoute?.title ?? '';

    return Scaffold(
      appBar: MainAppBar(title: displayTitle),
      drawer: SideBar(
        currentRoute: currentRoute,
        onRouteSelected: (targetRoute) =>
            AppRoutes.navigateTo(context, targetRoute, currentRoute),
      ),
      body: child,
    );
  }
}
