import 'package:flutter/material.dart';

import '../navigation/app_routes.dart';
import 'main_app_bar.dart';
import 'side_bar.dart';

/// AppShell ist das zentrale Master-Layout (Scaffold, AppBar, SideBar),
/// welches das Grundgerüst der gesamten Anwendung bereitstellt.
/// Die einzelnen Hauptseiten werden über ein IndexedStack geladen.
class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  AppRoute _currentRoute = AppRoute.mainPage;

  void _onRouteSelected(AppRoute route) {
    Navigator.pop(context); // Drawer schliessen.
    if (route != _currentRoute) {
      setState(() {
        _currentRoute = route;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(title: _currentRoute.title),
      drawer: SideBar(
        currentRoute: _currentRoute,
        onRouteSelected: _onRouteSelected,
      ),
      body: IndexedStack(
        index: _currentRoute.index,
        children: AppRoute.values.map((route) => route.buildPage()).toList(),
      ),
    );
  }
}
