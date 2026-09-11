import 'package:flutter/material.dart';
import '../widgets/offline_banner.dart';
import 'class_screen.dart';
import 'teacher_screen.dart';

class StationScreen extends StatefulWidget {
  final String teacherName;

  const StationScreen({super.key, required this.teacherName});

  @override
  State<StationScreen> createState() => _StationScreenState();
}

class _StationScreenState extends State<StationScreen> {
  final String primaryStation = 'Kugelstoßen'; // Primär zugewiesene Übung

  final List<String> allStations = const [
    'Frisbee-Zielwurf',
    'Kugelstoßen',
    'Sprint 100m',
    'Weitsprung',
  ];

  String searchQuery = '';

  void _selectStation(String station) {
    if (station == primaryStation) {
      _navigateToClass(station);
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Übung wechseln?'),
          content: Text(
            'Deine primär zugewiesene Übung ist "$primaryStation".\n\nMöchtest du temporär zu "$station" wechseln, um dort Ergebnisse einzutragen?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Abbrechen'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.orange, foregroundColor: Colors.white),
              onPressed: () {
                Navigator.pop(context);
                _navigateToClass(station);
              },
              child: const Text('Wechseln'),
            ),
          ],
        ),
      );
    }
  }

  void _navigateToClass(String station) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClassScreen(
          teacherName: widget.teacherName,
          stationName: station,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final otherStations = allStations
        .where((s) => s != primaryStation && s.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList()..sort();

    final showPrimary = primaryStation.toLowerCase().contains(searchQuery.toLowerCase());

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
                    child: InkWell(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const TeacherScreen()),
                              (route) => false,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.person, color: Colors.orange, size: 18),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                widget.teacherName,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
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
                          Icon(Icons.fitness_center, color: Colors.orange, size: 18),
                          SizedBox(width: 6),
                          Text('Übung wählen', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange)),
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
                  hintText: 'Übung suchen...',
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

              // LISTE DER ÜBUNGEN (Zerstückelt in Betreut vs. Andere)
              Expanded(
                child: ListView(
                  children: [
                    if (showPrimary) ...[
                      Card(
                        color: Colors.orange[50],
                        margin: const EdgeInsets.symmetric(vertical: 4),
                        elevation: 2,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: const BorderSide(color: Colors.orange, width: 1.5),
                        ),
                        child: ListTile(
                          leading: const Icon(Icons.star, color: Colors.orange, size: 28),
                          title: Text(
                            primaryStation,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          subtitle: const Text(
                            'Deine zugewiesene Hauptstation',
                            style: TextStyle(color: Colors.orange, fontWeight: FontWeight.w600, fontSize: 12),
                          ),
                          onTap: () => _selectStation(primaryStation),
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Row(
                        children: [
                          Expanded(child: Divider(thickness: 1)),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text('Weitere Übungen', style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
                          ),
                          Expanded(child: Divider(thickness: 1)),
                        ],
                      ),
                      const SizedBox(height: 8),
                    ],
                    ...otherStations.map((station) => Card(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      elevation: 1,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      child: ListTile(
                        leading: const Icon(Icons.fitness_center, color: Colors.grey),
                        title: Text(station),
                        onTap: () => _selectStation(station),
                      ),
                    )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}