import 'package:flutter/material.dart';
import '../../../../core/config/app_settings.dart';
import '../../../../core/widgets/offline_banner.dart';
import '../../../../core/widgets/top_banner.dart';
import '../../../event/presentation/screens/event_selection_screen.dart';
import '../../../station/presentation/screens/station_screen.dart';

class TeacherItem {
  final String name;
  final bool isLocalOnly;

  TeacherItem({required this.name, this.isLocalOnly = false});
}

class TeacherScreen extends StatefulWidget {
  const TeacherScreen({super.key});

  @override
  State<TeacherScreen> createState() => _TeacherScreenState();
}

class _TeacherScreenState extends State<TeacherScreen> {
  final List<TeacherItem> teachers = [
    TeacherItem(name: 'Hr. Fischer'),
    TeacherItem(name: 'Fr. Müller'),
    TeacherItem(name: 'Fr. Schmidt'),
    TeacherItem(name: 'Hr. Weber'),
  ];

  String searchQuery = '';
  final appSettings = AppSettings();

  final GlobalKey _eventHeaderKey = GlobalKey();
  final GlobalKey _headerKey = GlobalKey();
  final GlobalKey _listKey = GlobalKey();
  final GlobalKey _searchKey = GlobalKey();
  final GlobalKey _addBtnKey = GlobalKey();
  final GlobalKey _settingsBtnKey = GlobalKey();

  int? tutorialStep;

  void _startTutorial() {
    setState(() => tutorialStep = 0);
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

  void _openAddTeacherDialog() {
    final nameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Lehrer hinzufügen'),
          content: TextField(
            controller: nameController,
            autofocus: true,
            decoration: const InputDecoration(hintText: 'Name (z.B. Hr. Schulze)'),
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
                    teachers.add(TeacherItem(name: newName, isLocalOnly: true));
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

  void _openSettings() {
    final passwordController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return ListenableBuilder(
          listenable: appSettings,
          builder: (context, _) {
            return Padding(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.tune, color: Colors.orange),
                            SizedBox(width: 8),
                            Text('Einstellungen', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                    const Divider(),
                    const SizedBox(height: 10),

                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Row(
                            children: [
                              Icon(Icons.style, color: Colors.orange, size: 20),
                              SizedBox(width: 6),
                              Text('Synchronisation', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                            ],
                          ),
                          const SizedBox(height: 12),

                          ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 42),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            onPressed: appSettings.isSyncing
                                ? null
                                : () async {
                              await appSettings.syncWithServer();
                              if (context.mounted) {
                                TopBanner.show(
                                  context,
                                  message: 'Konfiguration vom Server geladen!',
                                  backgroundColor: Colors.green.shade700,
                                  icon: Icons.cloud_done,
                                );
                              }
                            },
                            icon: appSettings.isSyncing
                                ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                            )
                                : const Icon(Icons.cloud_download, size: 18),
                            label: Text(
                              appSettings.isSyncing ? 'Synchronisiere Konfiguration...' : 'Konfiguration vom Server laden',
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: appSettings.canDeleteItems ? Colors.red[50] : Colors.orange[50],
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: appSettings.canDeleteItems ? Colors.red.shade300 : Colors.orange.shade300,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                appSettings.canDeleteItems ? Icons.timer : Icons.lock,
                                color: appSettings.canDeleteItems ? Colors.red[800] : Colors.orange[800],
                                size: 20,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                appSettings.canDeleteItems ? 'Löschen aktiv (${appSettings.adminRemainingSeconds}s)' : 'Löschen freischalten (Admin)',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15,
                                  color: appSettings.canDeleteItems ? Colors.red[900] : Colors.orange[900],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),

                          if (!appSettings.canDeleteItems) ...[
                            const Text(
                              'Geben Sie das Passwort ein, um auf allen Seiten Lösch-Buttons für 3 Minuten freizuschalten:',
                              style: TextStyle(fontSize: 12.5, color: Colors.black87),
                            ),
                            const SizedBox(height: 10),
                            Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: passwordController,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      hintText: 'Passwort (admin)',
                                      filled: true,
                                      fillColor: Colors.white,
                                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(color: Colors.grey.shade300),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange[800],
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                  onPressed: () {
                                    if (passwordController.text.trim() == 'admin') {
                                      appSettings.enableAdminToolsFor3Minutes();
                                      TopBanner.show(
                                        context,
                                        message: 'Löschen für 3 Minuten freigeschaltet!',
                                        backgroundColor: Colors.green.shade700,
                                        icon: Icons.lock_open,
                                      );
                                    } else {
                                      TopBanner.show(
                                        context,
                                        message: 'Falsches Admin-Passwort!',
                                        backgroundColor: Colors.red.shade700,
                                        icon: Icons.error_outline,
                                      );
                                    }
                                  },
                                  child: const Text('Freischalten'),
                                ),
                              ],
                            ),
                          ] else ...[
                            const Text(
                              'Lösch-Buttons sind jetzt auf allen Seiten für Korrekturen aktiv.',
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.red),
                            ),
                            const SizedBox(height: 10),
                            OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.red,
                                side: const BorderSide(color: Colors.red),
                                minimumSize: const Size(double.infinity, 40),
                              ),
                              onPressed: () => appSettings.disableAdminToolsManually(),
                              icon: const Icon(Icons.lock, size: 18),
                              label: const Text('Löschen sofort wieder sperren'),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Rect? _getWidgetRect(GlobalKey key) {
    final renderBox = key.currentContext?.findRenderObject() as RenderBox?;
    if (renderBox == null) return null;
    final offset = renderBox.localToGlobal(Offset.zero);
    return offset & renderBox.size;
  }

  @override
  Widget build(BuildContext context) {
    final filteredTeachers = teachers
        .where((t) => t.name.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));

    return Scaffold(
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.small(
            heroTag: 'helpBtn',
            onPressed: _startTutorial,
            backgroundColor: Colors.orange[700],
            child: const Icon(Icons.help_outline, color: Colors.white),
          ),
        ],
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

                  Row(
                    children: [
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
                      const SizedBox(width: 8),

                      Expanded(
                        child: Container(
                          key: _headerKey,
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
                          decoration: BoxDecoration(
                            color: Colors.orange[100],
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.orange),
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.person, color: Colors.orange, size: 16),
                              SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  'Lehrer wählen',
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

                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          key: _searchKey,
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
                          onPressed: _openAddTeacherDialog,
                          child: const Icon(Icons.add, size: 24),
                        ),
                      ),
                      const SizedBox(width: 8),

                      SizedBox(
                        key: _settingsBtnKey,
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
                          onPressed: _openSettings,
                          child: const Icon(Icons.settings, size: 22),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  Expanded(
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Container(
                        key: _listKey,
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: const ClampingScrollPhysics(),
                          itemCount: filteredTeachers.length,
                          itemBuilder: (context, index) {
                            final teacher = filteredTeachers[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              elevation: 1,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              child: ListTile(
                                leading: const Icon(Icons.person, color: Colors.orange),
                                title: Text(teacher.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    if (teacher.isLocalOnly)
                                      Container(
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
                                      ),
                                    ListenableBuilder(
                                      listenable: appSettings,
                                      builder: (context, _) {
                                        if (appSettings.canDeleteItems && teacher.isLocalOnly) {
                                          return IconButton(
                                            icon: const Icon(Icons.delete_outline, color: Colors.red),
                                            onPressed: () {
                                              setState(() => teachers.remove(teacher));
                                            },
                                          );
                                        }
                                        return const SizedBox.shrink();
                                      },
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => StationScreen(teacherName: teacher.name),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
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
        description = 'Klicken Sie links auf den Event-Namen, um zur Event-Auswahl zurückzukehren.';
        break;
      case 1:
        currentKey = _listKey;
        title = '2/5: Lehrer auswählen';
        description = 'Klicken Sie auf Ihren Namen in der Liste, um das Sportfest als betreuende Lehrkraft zu starten.';
        break;
      case 2:
        currentKey = _searchKey;
        title = '3/5: Suche nutzen';
        description = 'Hier können Sie schnell nach Ihrem Nachnamen filtern, um sich nicht durch die gesamte Liste scrollen zu müssen.';
        break;
      case 3:
        currentKey = _addBtnKey;
        title = '4/5: Lehrer hinzufügen';
        description = 'Falls Ihr Name in der Liste fehlt (z. B. bei Vertretungen), können Sie sich hier über das Plus-Symbol eintragen.';
        break;
      case 4:
        currentKey = _settingsBtnKey;
        title = '5/5: Einstellungen & Sync';
        description = 'Hier aktivieren Sie Admin-Tools und synchronisieren die Daten vom Server.';
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
