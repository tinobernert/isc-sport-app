import 'package:flutter/material.dart';

import '../widgets/SideBar.dart';
import '../widgets/AppBar.dart';
import '../widgets/MainContent.dart';

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