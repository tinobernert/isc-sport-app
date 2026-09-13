import 'package:flutter/material.dart';
import '../widgets/offline_banner.dart';
import '../services/api_service.dart';
import 'score_entry_screen.dart';
import 'station_screen.dart';
import 'teacher_screen.dart';

class ClassScreen extends StatefulWidget {
  final String teacherName;
  final String stationName;

  const ClassScreen({
    super.key,
    required this.teacherName,
    required this.stationName,
  });

  @override
  State<ClassScreen> createState() => _ClassScreenState();
}

class _ClassScreenState extends State<ClassScreen> {
  String selectedBlock = 'A';
  late Future<List<dynamic>> _classesFuture;

  @override
  void initState() {
    super.initState();
    _classesFuture = ApiService.fetchClasses();
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
                    child: InkWell(
                      onTap: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context) => const TeacherScreen()),
                              (route) => false,
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.person, color: Colors.orange, size: 16),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                widget.teacherName,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => StationScreen(teacherName: widget.teacherName)),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.fitness_center, color: Colors.orange, size: 16),
                            const SizedBox(width: 4),
                            Flexible(
                              child: Text(
                                widget.stationName,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.orange[100],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.orange),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.groups, color: Colors.orange, size: 16),
                          SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              'Klasse wählen',
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange, fontSize: 13),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // BLOCK TABS (A, B, C)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: ['A', 'B', 'C'].map((block) {
                  final isSelected = selectedBlock == block;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ChoiceChip(
                      label: Text(
                        'Block $block',
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      selected: isSelected,
                      selectedColor: Colors.orange,
                      backgroundColor: Colors.white,
                      onSelected: (selected) {
                        if (selected) setState(() => selectedBlock = block);
                      },
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),

              // DYNAMISCHER INHALT AUS DER API
              Expanded(
                child: FutureBuilder<List<dynamic>>(
                  future: _classesFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator(color: Colors.orange));
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Fehler beim Laden der Klassen:\n${snapshot.error}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('Keine Klassen in der Datenbank gefunden.'));
                    }

                    final allClassList = snapshot.data!;

                    // 1. Filtern nach aktuell gewähltem Block (A, B oder C)
                    final blockClasses = allClassList.where((c) => c['block'] == selectedBlock).toList();

                    // 2. Zuordnen nach Jahrgängen (24, 25, 26)
                    final Map<String, List<dynamic>> classesByYear = {
                      '24er': blockClasses.where((c) => c['year'].toString() == '24').toList(),
                      '25er': blockClasses.where((c) => c['year'].toString() == '25').toList(),
                      '26er': blockClasses.where((c) => c['year'].toString() == '26').toList(),
                    };

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: ['24er', '25er', '26er'].map((yearKey) {
                        final classList = classesByYear[yearKey] ?? [];

                        return Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4.0),
                            child: Column(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(vertical: 6),
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    'Jahrgang $yearKey',
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                      color: Colors.black87,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),

                                // Rendere die Klassen-Buttons für diesen Jahrgang
                                ...classList.map((classData) {
                                  final String className = classData['name']; // z.B. "ITF24A1"

                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: SizedBox(
                                      width: double.infinity,
                                      height: 55,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          foregroundColor: Colors.black87,
                                          elevation: 1,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ScoreEntryScreen(
                                                teacherName: widget.teacherName,
                                                stationName: widget.stationName,
                                                className: className,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          className,
                                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
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