import 'package:flutter/material.dart';

import 'core/constants/app_strings.dart';
import 'core/theme/app_theme.dart';
import 'core/widgets/app_shell.dart';

/// Einstiegspunkt der SportPoint-Anwendung.
void main() {
  runApp(const MyApp());
}

/// Root-Widget der Anwendung.
class MyApp extends StatelessWidget {
  /// Erstellt eine neue [MyApp].
  const MyApp({super.key});

  /// Der Name der Anwendung.
  static const String appTitle = 'SportPoint';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: AppStrings.appName,
      theme: AppTheme.lightTheme,
      home: const AppShell(),
    );
  }
}
