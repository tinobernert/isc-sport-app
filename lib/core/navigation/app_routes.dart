import 'package:flutter/material.dart';

import '../../features/create_disziplin/pages/disziplin_page.dart';
import '../../features/enter_points/pages/enter_points_page.dart';
import '../../features/classes/pages/classes_page.dart';
import '../../features/main_screen/pages/main_page.dart';
import '../../features/ranking/pages/ranking_page.dart';
import '../../features/settings/pages/settings_page.dart';

class AppRoutes {
  static void navigate(BuildContext context, int index, int? currentIndex) {
    Navigator.pop(context); // Sidebar schliessen.
    if (index == currentIndex) return;

    final Widget page;
    switch (index) {
      case 0:
        page = const MainPage();
        break;
      case 1:
        page = const RankingPage();
        break;
      case 2:
        page = const EnterPointsPage();
        break;
      case 3:
        page = const DisziplinPage();
        break;
      case 4:
        page = const ClassesPage();
        break;
      case 5:
        page = const SettingsPage();
        break;
      default:
        return;
    }

    Navigator.pushReplacement(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionDuration: Duration.zero,
        reverseTransitionDuration: Duration.zero,
      ),
    );
  }
}
