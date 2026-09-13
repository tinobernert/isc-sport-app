import 'package:flutter/material.dart';
import '../services/api_service.dart'; // Passe den Pfad ggf. an deine Ordnerstruktur an
import '../widgets/offline_banner.dart';
import 'station_screen.dart';

class TeacherScreen extends StatefulWidget {
  const TeacherScreen({super.key});

  @override
  State<TeacherScreen> createState() => _TeacherScreenState();
}

class _TeacherScreenState extends State<TeacherScreen> {
  late Future<List<dynamic>> _teachersFuture;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    _loadTeachers();
  }

  void _loadTeachers() {
    setState(() {
      _teachersFuture = ApiService.fetchTeachers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
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

              // DYNAMISCHE LEHRER-LISTE MIT FUTUREBUILDER
              Expanded(
                child: FutureBuilder<List<dynamic>>(
                  future: _teachersFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(
                        child: CircularProgressIndicator(color: Colors.orange),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.error_outline, color: Colors.red, size: 40),
                            const SizedBox(height: 8),
                            Text(
                              'Fehler beim Laden:\n${snapshot.error}',
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.red),
                            ),
                            const SizedBox(height: 12),
                            ElevatedButton(
                              onPressed: _loadTeachers,
                              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
                              child: const Text('Erneut versuchen', style: TextStyle(color: Colors.white)),
                            ),
                          ],
                        ),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(
                        child: Text('Keine Lehrer gefunden.'),
                      );
                    }

                    // Alle geladenen Lehrer aus dem Backend
                    final allTeachers = snapshot.data!;

                    // Filterung nach Name
                    final filteredTeachers = allTeachers.where((teacher) {
                      final name = teacher['name'].toString().toLowerCase();
                      return name.contains(searchQuery.toLowerCase());
                    }).toList()
                      ..sort((a, b) => a['name'].toString().compareTo(b['name'].toString()));

                    if (filteredTeachers.isEmpty) {
                      return const Center(
                        child: Text('Kein Lehrer entspricht deiner Suche.'),
                      );
                    }

                    return ListView.builder(
                      itemCount: filteredTeachers.length,
                      itemBuilder: (context, index) {
                        final teacher = filteredTeachers[index];
                        final String teacherName = teacher['name'];

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          elevation: 1,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          child: ListTile(
                            leading: const Icon(Icons.person, color: Colors.orange),
                            title: Text(
                              teacherName,
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => StationScreen(teacherName: teacherName),
                                ),
                              );
                            },
                          ),
                        );
                      },
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