import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Die standardmäßige AppBar der SportPoint-Anwendung mit Menü-Button zum Öffnen der Sidebar.
class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// Titel der aktuellen Seite in der AppBar.
  final String title;

  /// Erstellt eine neue [MainAppBar].
  const MainAppBar({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primaryLight,
      title: Text(title),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
