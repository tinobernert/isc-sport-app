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
      backgroundColor: Colors.white,
      foregroundColor: Colors.black87,
      elevation: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          color: AppColors.grey200,
          height: 1,
        ),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 1);
}
