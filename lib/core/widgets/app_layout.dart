import 'package:flutter/material.dart';

import '../navigation/app_routes.dart';
import 'main_app_bar.dart';
import 'side_bar.dart';

class AppLayout extends StatelessWidget {
  const AppLayout({
    super.key,
    this.currentRoute,
    this.title,
    required this.child,
  });

  final AppRoute? currentRoute;
  final String? title;
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
