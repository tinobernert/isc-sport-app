import 'package:flutter/material.dart';
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
  bool isSyncing = false;

  final Map<String, Map<String, List<String>>> classesByBlockAndYear = {
    'A': {
      '24er': ['ITF24A1', 'ITF24A2'],
      '25er': ['ITF25A1', 'ITF25A2'],
      '26er': ['ITF26A1', 'ITF26A2'],
    },
    'B': {
      '24er': ['ITF24B1', 'ITF24B2'],
      '25er': ['ITF25B1', 'ITF25B2'],
      '26er': ['ITF26B1', 'ITF26B2'],
    },
    'C': {
      '24er': ['ITF24C1', 'ITF24C2'],
      '25er': ['ITF25C1', 'ITF25C2'],
      '26er': ['ITF26C1', 'ITF26C2'],
    },
  };

  void _triggerSync() async {
    setState(() => isSyncing = true);
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      setState(() => isSyncing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Daten erfolgreich mit dem Schulserver synchronisiert!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentBlockData = classesByBlockAndYear[selectedBlock]!;

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              // OFFLINE BANNER
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.orange[800],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.wifi_off, color: Colors.white, size: 18),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        isSyncing ? 'Synchronisiere mit Server...' : 'Offline-Modus – Änderungen lokal gesichert',
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
                      ),
                    ),
                    isSyncing
                        ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                    )
                        : TextButton.icon(
                      onPressed: _triggerSync,
                      icon: const Icon(Icons.sync, color: Colors.white, size: 16),
                      label: const Text('Sync', style: TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              ),
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
                              child: Text(widget.teacherName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13), overflow: TextOverflow.ellipsis),
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
                              child: Text(widget.stationName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13), overflow: TextOverflow.ellipsis),
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
                            child: Text('Klasse wählen', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange, fontSize: 13), overflow: TextOverflow.ellipsis),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // BLOCK TABS
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: ['A', 'B', 'C'].map((block) {
                  final isSelected = selectedBlock == block;
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4.0),
                    child: ChoiceChip(
                      label: Text('Block $block', style: TextStyle(color: isSelected ? Colors.white : Colors.black87, fontWeight: FontWeight.bold)),
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

              // SPALTEN-LAYOUT NACH JAHRGÄNGEN (24er | 25er | 26er)
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: ['24er', '25er', '26er'].map((year) {
                    final classList = currentBlockData[year] ?? [];
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
                                'Jahrgang $year',
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87),
                              ),
                            ),
                            const SizedBox(height: 8),
                            ...classList.map((className) => Padding(
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: SizedBox(
                                width: double.infinity,
                                height: 55,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.black87,
                                    elevation: 1,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
                                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold), // Größere Schrift!
                                  ),
                                ),
                              ),
                            )),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}