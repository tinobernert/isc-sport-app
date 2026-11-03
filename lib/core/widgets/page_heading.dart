import 'package:flutter/material.dart';

class PageHeading extends StatelessWidget {
  final String title;

  const PageHeading({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
        fontWeight: FontWeight.w600,
      ),
    );
  }
}
