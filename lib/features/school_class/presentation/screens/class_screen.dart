import 'package:flutter/material.dart';
import '../../../../core/config/app_settings.dart';
import '../../../../core/widgets/offline_banner.dart';
import '../../../event/presentation/screens/event_selection_screen.dart';
import '../../../score_entry/presentation/screens/score_entry_screen.dart';
import '../../../station/presentation/screens/station_screen.dart';
import '../../../teacher/presentation/screens/teacher_screen.dart';

class ClassItem {
  final String name;
  final bool isLocalOnly;

  ClassItem({required this.name, this.isLocalOnly = false});
}

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
  final appSettings = AppSettings();

  // Klassen geordnet nach Blöcken (A, B, C) und Jahrgängen (24er, 25er, 26er)
  final Map<String, Map<String, List<ClassItem>>> classesByBlockAndYear = {
    'A': {
      '24er': [ClassItem(name: 'ITF24A1'), ClassItem(name: 'ITF24A2')],
      '25er': [ClassItem(name: 'ITF25A1'), ClassItem(name: 'ITF25A2')],
      '26er': [ClassItem(name: 'ITF26A1'), ClassItem(name: 'ITF26A2')],
    },
    'B': {
      '24er': [ClassItem(name: 'ITF24B1'), ClassItem(name: 'ITF24B2')],
      '25er': [ClassItem(name: 'ITF25B1'), ClassItem(name: 'ITF25B2')],
      '26er': [ClassItem(name: 'ITF26B1'), ClassItem(name: 'ITF26B2')],
    },
    'C': {
      '24er': [ClassItem(name: 'ITF24C1'), ClassItem(name: 'ITF24C2')],
      '25er': [ClassItem(name: 'ITF25C1'), ClassItem(name: 'ITF25C2')],
      '26er': [ClassItem(name: 'ITF26C1'), ClassItem(name: 'ITF26C2')],
    },
  };

  // Keys für das Spotlight-Tutorial
  final GlobalKey _eventHeaderKey = GlobalKey();
  final GlobalKey _teacherHeaderKey = GlobalKey();
  final GlobalKey _stationHeaderKey = GlobalKey();
  final GlobalKey _addBtnKey = GlobalKey();
  final GlobalKey _classGridKey = GlobalKey();

  int? tutorialStep;

  void _startTutorial() {
    setState(() {
      tutorialStep = 0;
    });
  }

  void _nextTutorialStep() {
    setState(() {
      if (tutorialStep != null && tutorialStep! < 4) {
        tutorialStep = tutorialStep! + 1;
      } else {
        tutorialStep = null;
      }
    });
  }

  Rect? _getWidgetRect(GlobalKey key) {
    final renderBox = key.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return null;
    final offset = renderBox.localToGlobal(Offset.zero);
    return offset & renderBox.size;
  }

  // DIALOG ZUM HINZUFÜGEN EINER KLASSE (FÜGT DIE KLASSE DEM AKTIVEN EVENT-BLOCK ZU)
  void _openAddClassDialog(String currentBlock) {
    final nameController = TextEditingController();
    String selectedYear = '24er';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Klasse zu Block $currentBlock hinzufügen',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: nameController,
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: 'Klassenname (z.B. ITF24${currentBlock}3)',
                          filled: true,
                          fillColor: Colors.grey[100],
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      DropdownButtonFormField<String>(
                        value: selectedYear,
                        isExpanded: true,
                        decoration: InputDecoration(
                          labelText: 'Jahrgang auswählen',
                          labelStyle: TextStyle(color: Colors.grey[700]),
                          filled: true,
                          fillColor: Colors.grey[100],
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                        ),
                        items: ['24er', '25er', '26er'].map((y) {
                          return DropdownMenuItem(
                            value: y,
                            child: Text('Jahrgang $y', style: const TextStyle(fontSize: 14)),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) setModalState(() => selectedYear = val);
                        },
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Abbrechen'),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                            ),
                            onPressed: () {
                              final newName = nameController.text.trim();
                              if (newName.isNotEmpty) {
                                setState(() {
                                  classesByBlockAndYear[currentBlock]?[selectedYear]?.add(
                                    ClassItem(name: newName, isLocalOnly: true),
                                  );
                                });
                                Navigator.pop(context);
                              }
                            },
                            child: const Text('Hinzufügen', style: TextStyle(fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Liest den im Event eingestellten Block aus (Fallback ist 'B')
    final activeBlock = appSettings.selectedBlockConfig != 'ALL'
        ? appSettings.selectedBlockConfig
        : 'B';

    final currentBlockData = classesByBlockAndYear[activeBlock] ?? classesByBlockAndYear['B']!;

    return Scaffold(
      floatingActionButton: FloatingActionButton.small(
        heroTag: 'classHelpBtn',
        onPressed: _startTutorial,
        backgroundColor: Colors.orange[700],
        child: const Icon(Icons.help_outline, color: Colors.white),
      ),
      body: Stack(
        children: [
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  const OfflineBanner(),
                  const SizedBox(height: 12),

                  // HEADER CHIPS: 4 CHIPS (EVENT | LEHRER | ÜBUNG | KLASSE WÄHLEN [AKTIV])
                  Row(
                    children: [
                      // 1. EVENT CHIP
                      Expanded(
                        child: InkWell(
                          key: _eventHeaderKey,
                          onTap: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => const EventSelectionScreen()),
                                  (route) => false,
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.emoji_events, color: Colors.orange, size: 15),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    appSettings.activeEventCode,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),

                      // 2. LEHRER CHIP
                      Expanded(
                        child: InkWell(
                          key: _teacherHeaderKey,
                          onTap: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => const TeacherScreen()),
                                  (route) => false,
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.person, color: Colors.orange, size: 15),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    widget.teacherName,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),

                      // 3. ÜBUNG CHIP
                      Expanded(
                        child: InkWell(
                          key: _stationHeaderKey,
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => StationScreen(teacherName: widget.teacherName)),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.fitness_center, color: Colors.orange, size: 15),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    widget.stationName,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),

                      // 4. KLASSE WÄHLEN CHIP (AKTIV ORANGE)
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 6),
                          decoration: BoxDecoration(
                            color: Colors.orange[100],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.orange),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.groups, color: Colors.orange, size: 15),
                              SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  'Klasse wählen',
                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange, fontSize: 12),
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

                  // ANZEIGE DES AKTIVEM BLOCKS + HINZUFÜGEN BUTTON
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.orange[50],
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Colors.orange.shade300),
                        ),
                        child: Text(
                          'Klassen für Block $activeBlock',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      SizedBox(
                        key: _addBtnKey,
                        width: 40,
                        height: 40,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange[700],
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: EdgeInsets.zero,
                          ),
                          onPressed: () => _openAddClassDialog(activeBlock),
                          child: const Icon(Icons.add, size: 22),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // KLASSEN GRID NACH JAHRGÄNGEN
                  Expanded(
                    child: Container(
                      key: _classGridKey,
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
                                  ...classList.map((item) => Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: SizedBox(
                                      width: double.infinity,
                                      height: 55,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          foregroundColor: Colors.black87,
                                          elevation: 1,
                                          padding: const EdgeInsets.symmetric(horizontal: 8),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => ScoreEntryScreen(
                                                teacherName: widget.teacherName,
                                                stationName: widget.stationName,
                                                className: item.name,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Row(
                                          children: [
                                            ListenableBuilder(
                                              listenable: appSettings,
                                              builder: (context, _) {
                                                if (appSettings.canDeleteItems && item.isLocalOnly) {
                                                  return const SizedBox(width: 32);
                                                }
                                                return const SizedBox.shrink();
                                              },
                                            ),
                                            Expanded(
                                              child: Text(
                                                item.name,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                              ),
                                            ),
                                            ListenableBuilder(
                                              listenable: appSettings,
                                              builder: (context, _) {
                                                if (appSettings.canDeleteItems && item.isLocalOnly) {
                                                  return SizedBox(
                                                    width: 32,
                                                    child: IconButton(
                                                      padding: EdgeInsets.zero,
                                                      constraints: const BoxConstraints(),
                                                      icon: const Icon(Icons.delete_outline, color: Colors.red, size: 22),
                                                      onPressed: () {
                                                        setState(() {
                                                          classesByBlockAndYear[activeBlock]?[year]?.remove(item);
                                                        });
                                                      },
                                                    ),
                                                  );
                                                }
                                                return const SizedBox.shrink();
                                              },
                                            ),
                                          ],
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
                  ),
                ],
              ),
            ),
          ),

          if (tutorialStep != null) _buildSpotlightOverlay(),
        ],
      ),
    );
  }

  Widget _buildSpotlightOverlay() {
    GlobalKey? currentKey;
    String title = '';
    String description = '';

    switch (tutorialStep) {
      case 0:
        currentKey = _eventHeaderKey;
        title = '1/5: Event wechseln';
        description = 'Klicken Sie ganz links auf den Event-Namen, um zurück zur Event-Auswahl zu wechseln.';
        break;
      case 1:
        currentKey = _teacherHeaderKey;
        title = '2/5: Lehrkraft wechseln';
        description = 'Klicken Sie auf den Lehrer-Namen, um die betreuende Lehrkraft zu ändern.';
        break;
      case 2:
        currentKey = _stationHeaderKey;
        title = '3/5: Übung wechseln';
        description = 'Klicken Sie auf den Stations-Namen, um zu einer anderen Übung zu wechseln.';
        break;
      case 3:
        currentKey = _addBtnKey;
        title = '4/5: Klasse hinzufügen';
        description = 'Fehlt eine Klasse in der Übersicht? Über das Plus-Symbol oben rechts tragen Sie eine neue Klasse manuell nach.';
        break;
      case 4:
        currentKey = _classGridKey;
        title = '5/5: Klasse auswählen';
        description = 'Klicken Sie auf Ihre gewünschte Klasse, um direkt zur Schülereingabe zu gelangen.';
        break;
    }

    final targetRect = currentKey != null ? _getWidgetRect(currentKey) : null;

    return Stack(
      children: [
        if (targetRect != null)
          ColorFiltered(
            colorFilter: ColorFilter.mode(
              Colors.black.withValues(alpha: 0.65),
              BlendMode.srcOut,
            ),
            child: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    backgroundBlendMode: BlendMode.dstOut,
                  ),
                ),
                Positioned(
                  left: targetRect.left - 4,
                  top: targetRect.top - 4,
                  width: targetRect.width + 8,
                  height: targetRect.height + 8,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ],
            ),
          )
        else
          Container(color: Colors.black.withValues(alpha: 0.65)),

        Positioned(
          left: 20,
          right: 90,
          bottom: 30,
          child: Align(
            alignment: Alignment.bottomLeft,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 520),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: const [
                    BoxShadow(color: Colors.black38, blurRadius: 12, offset: Offset(0, 4)),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.info_outline, color: Colors.orange, size: 30),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            title,
                            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(
                      description,
                      style: const TextStyle(fontSize: 15, height: 1.4, color: Colors.black87),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.black87,
                            side: BorderSide(color: Colors.grey.shade400),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                          ),
                          onPressed: () => setState(() => tutorialStep = null),
                          child: const Text(
                            'Abbrechen',
                            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Row(
                          children: [
                            if (tutorialStep != null && tutorialStep! > 0)
                              OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Colors.orange),
                                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                                ),
                                onPressed: () {
                                  setState(() {
                                    tutorialStep = tutorialStep! - 1;
                                  });
                                },
                                child: const Text(
                                  'Zurück',
                                  style: TextStyle(color: Colors.orange, fontSize: 14, fontWeight: FontWeight.bold),
                                ),
                              ),
                            if (tutorialStep != null && tutorialStep! > 0)
                              const SizedBox(width: 8),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                              ),
                              onPressed: _nextTutorialStep,
                              child: Text(
                                tutorialStep == 4 ? 'Fertig' : 'Weiter',
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
