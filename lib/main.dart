import 'package:flutter/material.dart';
import 'features/teacher/presentation/screens/teacher_screen.dart';

void main() {
  runApp(const SportpointApp());
}

class SportpointApp extends StatelessWidget {
  const SportpointApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sportpoint',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      ),
      home: const TeacherScreen(),
    );
  }
}
