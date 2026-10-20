import 'package:flutter/material.dart';
import '../../../../core/config/app_settings.dart';
import '../../../../core/widgets/offline_banner.dart';
import '../../../event/presentation/screens/event_selection_screen.dart';
import '../../../school_class/presentation/screens/class_screen.dart';
import '../../../teacher/presentation/screens/teacher_screen.dart';

class StationItem {
  final String name;
  final bool isLocalOnly;

  StationItem({required this.name, this.isLocalOnly = false});
}

class StationScreen extends StatefulWidget {
  final String teacherName;

  const StationScreen({super.key, required this.teacherName});

  @override
  State<StationScreen> createState() => _StationScreenState();
}

class _StationScreenState extends State<StationScreen> {
  final String primaryStation = 'Kugelstoßen';
  final appSettings = AppSettings();

  final List<StationItem> allStations = [
    StationItem(name: 'Frisbee-Zielwurf'),
    StationItem(name: 'Kugelstoßen'),
    StationItem(name: 'Sprint 100m'),
    StationItem(name: 'Weitsprung'),
  ];

  String searchQuery = '';

  final GlobalKey _eventHeaderKey = GlobalKey();
  final GlobalKey _teacherHeaderKey = GlobalKey();
  final GlobalKey _primaryStationKey = GlobalKey();
  final GlobalKey _otherStationsKey = GlobalKey();
  final GlobalKey _searchKey = GlobalKey();
  final GlobalKey _addBtnKey = GlobalKey();

  int? tutorialStep;

  void _startTutorial() {
    setState(() => tutorialStep = 0);
  }

  void _nextTutorialStep() {
    setState(() {
      if (tutorialStep != null && tutorialStep! < 5) {
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

  void _openAddStationDialog() {
    final nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Übung hinzufügen'),
          content: TextField(
            controller: nameController,
            autofocus: true,
            decoration: const InputDecoration(hintText: 'Name der Übung (z.B. Hochsprung)'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Abbrechen'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                final newName = nameController.text.trim();
                if (newName.isNotEmpty) {
                  setState(() {
                    allStations.add(StationItem(name: newName, isLocalOnly: true));
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Hinzufügen'),
            ),
          ],
        );
      },
    );
  }

  void _selectStation(String station) {
    if (station == primaryStation) {
      _navigateToClass(station);
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Eckiger Dialog
          ),
          title: Row(
            children: [
              CircleAvatar(
                backgroundColor: Colors.orange[50],
                child: const Icon(Icons.swap_horiz, color: Colors.orange),
              ),
              const SizedBox(width: 10),
              const Text('Übung wechseln?'),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  style: const TextStyle(color: Colors.black87, fontSize: 14),
                  children: [
                    const TextSpan(text: 'Hauptstation: '),
                    TextSpan(
                      text: primaryStation,
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Möchtest du temporär zu "$station" wechseln, um dort Ergebnisse einzutragen?',
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
          actions: [
            // BARRIEREFREIER "ABBRECHEN"-BUTTON (DUNKLE SCHRIFT + ECKIG)
            TextButton(
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // Eckiger Button
                ),
              ),
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Abbrechen',
                style: TextStyle(
                  color: Colors.grey[850], // Hoher Kontrast für Barrierefreiheit
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
            const SizedBox(width: 8),

            // ECKIGER "WECHSELN"-BUTTON
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8), // Eckiger Button
                ),
                elevation: 0,
              ),
              onPressed: () {
                Navigator.pop(context);
                _navigateToClass(station);
              },
              child: const Text(
                'Wechseln',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              ),
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

  Widget _buildLocalBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.orange.shade400),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.cloud_off, color: Colors.orange, size: 12),
          SizedBox(width: 4),
          Text('Nur lokal', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 11)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final otherStations = allStations
        .where((s) => s.name != primaryStation && s.name.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));

    final showPrimary = primaryStation.toLowerCase().contains(searchQuery.toLowerCase());

    return Scaffold(
      floatingActionButton: FloatingActionButton.small(
        heroTag: 'stationHelpBtn',
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

                  // HEADER CHIPS: EXACT 3ER-TEILUNG (EVENT | LEHRER | ÜBUNG WÄHLEN [AKTIV])
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
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.emoji_events, color: Colors.orange, size: 16),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    appSettings.activeEventCode,
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

                      // 2. LEHRER CHIP
                      Expanded(
                        child: InkWell(
                          key: _teacherHeaderKey,
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => const TeacherScreen()),
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

                      // 3. ÜBUNG WÄHLEN CHIP (AKTIV ORANGE)
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
                              Icon(Icons.fitness_center, color: Colors.orange, size: 16),
                              SizedBox(width: 4),
                              Flexible(
                                child: Text('Übung wählen', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange, fontSize: 13), overflow: TextOverflow.ellipsis),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          key: _searchKey,
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
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        key: _addBtnKey,
                        width: 48,
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange[700],
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            padding: EdgeInsets.zero,
                          ),
                          onPressed: _openAddStationDialog,
                          child: const Icon(Icons.add, size: 24),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  Expanded(
                    child: ListView(
                      children: [
                        if (showPrimary) ...[
                          Card(
                            key: _primaryStationKey,
                            color: Colors.orange[50],
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                              side: const BorderSide(color: Colors.orange, width: 1.5),
                            ),
                            child: ListTile(
                              leading: const Icon(Icons.star, color: Colors.orange, size: 28),
                              title: Text(primaryStation, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                              subtitle: const Text('Deine zugewiesene Hauptstation', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.w600, fontSize: 12)),
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
                        Container(
                          key: _otherStationsKey,
                          child: Column(
                            children: otherStations.map((station) => Card(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              elevation: 1,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              child: ListTile(
                                leading: const Icon(Icons.fitness_center, color: Colors.grey),
                                title: Text(station.name),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (station.isLocalOnly) _buildLocalBadge(),
                                    ListenableBuilder(
                                      listenable: appSettings,
                                      builder: (context, _) {
                                        if (appSettings.canDeleteItems && station.isLocalOnly) {
                                          return IconButton(
                                            icon: const Icon(Icons.delete_outline, color: Colors.red),
                                            onPressed: () {
                                              setState(() {
                                                allStations.remove(station);
                                              });
                                            },
                                          );
                                        }
                                        return const SizedBox.shrink();
                                      },
                                    ),
                                  ],
                                ),
                                onTap: () => _selectStation(station.name),
                              ),
                            )).toList(),
                          ),
                        ),
                      ],
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
        title = '1/6: Event wechseln';
        description = 'Klicken Sie ganz links auf den Event-Namen, um zur Event-Auswahl zurückzukehren.';
        break;
      case 1:
        currentKey = _teacherHeaderKey;
        title = '2/6: Lehrkraft wechseln';
        description = 'Falsche Lehrkraft ausgewählt? Klicken Sie hier oben, um den Betreuer jederzeit zu ändern.';
        break;
      case 2:
        currentKey = _primaryStationKey;
        title = '3/6: Hauptstation wählen';
        description = 'Das ist Ihre zugewiesene Hauptstation. Klicken Sie darauf, um direkt zur Klassenauswahl zu gelangen.';
        break;
      case 3:
        currentKey = _otherStationsKey;
        title = '4/6: Weitere Übungen';
        description = 'Möchten Sie eine andere Übung betreuen? Wählen Sie einfach eine Station aus der Liste unter "Weitere Übungen".';
        break;
      case 4:
        currentKey = _searchKey;
        title = '5/6: Übung suchen';
        description = 'Suchen Sie gezielt nach einer Station, um nicht scrollen zu müssen.';
        break;
      case 5:
        currentKey = _addBtnKey;
        title = '6/6: Übung hinzufügen';
        description = 'Fehlt eine Übung? Über das Plus-Symbol tragen Sie eine neue Station manuell nach.';
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
                                  setState(() => tutorialStep = tutorialStep! - 1);
                                },
                                child: const Text('Zurück', style: TextStyle(color: Colors.orange, fontSize: 14, fontWeight: FontWeight.bold)),
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
                                tutorialStep == 5 ? 'Fertig' : 'Weiter',
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
