import 'package:flutter/material.dart';

class MainContent extends StatelessWidget {
  const MainContent({
    super.key,
    required this.selectedIndex,
  });

  final int selectedIndex;

  static const TextStyle optionStyle = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
  );

  static const List<Widget> widgetOptions = <Widget>[
    Center(
      child: Text(
        'Punkteauswertung',
        style: optionStyle,
      ),
    ),
    Center(
      child: Text(
        'Punkteeingabe',
        style: optionStyle,
      ),
    ),
    Center(
      child: Text(
        'Disziplinen',
        style: optionStyle,
      ),
    ),
    Center(
      child: Text(
        'Klassen',
        style: optionStyle,
      ),
    ),
    Center(
      child: Text(
        'Einstellungen',
        style: optionStyle,
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return widgetOptions[selectedIndex];
  }
}
