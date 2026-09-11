import 'package:flutter/material.dart';
import '../widgets/offline_banner.dart';
import 'station_screen.dart';

class TeacherScreen extends StatefulWidget {
  const TeacherScreen({super.key});

  @override
  State<TeacherScreen> createState() => _TeacherScreenState();
}

class _TeacherScreenState extends State<TeacherScreen> {
  final List<String> teachers = const [
    'Hr. Fischer',
    'Fr. Müller',
    'Fr. Schmidt',
    'Hr. Weber',
  ];

  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filteredTeachers = teachers
        .where((t) => t.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList()..sort();

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0), // 10px Sicherheitsabstand außen
          child: Column(
            children: [
              // OFFLINE BANNER WIDGET INKLUDIERT
              const OfflineBanner(),
              const SizedBox(height: 12),

              // HEADER CHIPS
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                      decoration: BoxDecoration(
                        color: Colors.orange[100],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.orange),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.person, color: Colors.orange, size: 18),
                          SizedBox(width: 6),
                          Text('Lehrer wählen', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // SUCHLEISTE
              TextField(
                onChanged: (val) => setState(() => searchQuery = val),
                decoration: InputDecoration(
                  hintText: 'Lehrer suchen...',
                  prefixIcon: const Icon(Icons.search, color: Colors.orange),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // LEHRER-LISTE (Flaches List-Card Design wie früher)
              Expanded(
                child: ListView.builder(
                  itemCount: filteredTeachers.length,
                  itemBuilder: (context, index) {
                    final teacher = filteredTeachers[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      elevation: 1,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      child: ListTile(
                        leading: const Icon(Icons.person, color: Colors.orange),
                        title: Text(teacher, style: const TextStyle(fontWeight: FontWeight.w600)),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => StationScreen(teacherName: teacher),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}