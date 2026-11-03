import 'package:flutter/material.dart';

import 'core/theme/app_theme.dart';
import 'features/main_screen/pages/main_page.dart';

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
      home: const MainPage(),
    );
  }
}
