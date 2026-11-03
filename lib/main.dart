import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'core/widgets/app_shell.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  static const String appTitle = 'SportPoint';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: appTitle,
      theme: AppTheme.lightTheme,
      home: const AppShell(),
    );
  }
}
