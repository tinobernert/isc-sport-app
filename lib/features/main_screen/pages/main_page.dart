import 'package:flutter/material.dart';

import '../../../core/widgets/main_app_bar.dart';
import '../../../core/widgets/side_bar.dart';
import '../widgets/main_content.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
    required this.title,
  });

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),

      appBar: MainAppBar(title: widget.title),

      drawer: SideBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          _onItemTapped(index);
          Navigator.pop(context);
        },
      ),

      body: MainContent(
        selectedIndex: _selectedIndex,
      ),
    );
  }
}
