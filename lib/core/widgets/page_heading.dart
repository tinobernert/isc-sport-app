import 'package:flutter/material.dart';

class PageHeading extends StatelessWidget{
  final String title;
  const PageHeading({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(title,
    style: TextStyle(
    fontSize: 24,
    color: Colors.black,
    fontWeight: FontWeight.bold,
    fontStyle: FontStyle.italic,
  ),);
  }

}