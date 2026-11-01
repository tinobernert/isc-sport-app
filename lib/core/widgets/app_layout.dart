import 'package:flutter/material.dart';

import '../navigation/app_routes.dart';
import 'main_app_bar.dart';
import 'side_bar.dart';

class AppLayout extends StatelessWidget {
  const AppLayout({
    super.key,
    required this.title,
    required this.child,
    this.selectedIndex,
  });

  final String title;
  final int? selectedIndex;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: MainAppBar(title: title),
      drawer: SideBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) =>
            AppRoutes.navigate(context, index, selectedIndex),
      ),
      body: child,
    );
  }
}
