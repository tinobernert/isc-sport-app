import 'package:flutter/material.dart';
import '../../../../core/config/app_settings.dart';
import '../../../../core/widgets/offline_banner.dart';
import '../../../../core/widgets/top_banner.dart';
import '../../../teacher/presentation/screens/teacher_screen.dart';
import '../../domain/models/event_item.dart';

class EventSelectionScreen extends StatefulWidget {
  const EventSelectionScreen({super.key});

  @override
  State<EventSelectionScreen> createState() => _EventSelectionScreenState();
}

class _EventSelectionScreenState extends State<EventSelectionScreen> {
  final appSettings = AppSettings();
  String searchQuery = '';

  final GlobalKey _activeEventKey = GlobalKey();
  final GlobalKey _historyKey = GlobalKey();
  final GlobalKey _searchKey = GlobalKey();
  final GlobalKey _settingsBtnKey = GlobalKey();

  int? tutorialStep;

  void _startTutorial() {
    setState(() => tutorialStep = 0);
  }

  void _nextTutorialStep() {
    setState(() {
      if (tutorialStep != null && tutorialStep! < 3) {
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

  void _openEventAdminSettings() {
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
                            Icon(Icons.admin_panel_settings, color: Colors.orange),
                            SizedBox(width: 8),
                            Text('Einstellungen & Admin Tools', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
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

                    // SERVER SYNC
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
                            message: 'Events & Konfiguration vom Server geladen!',
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
                        appSettings.isSyncing ? 'Synchronisiere Server-Events...' : 'Events vom Server laden',
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ADMIN TOOLS CONTAINER
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: appSettings.adminToolsActive ? Colors.orange[50] : Colors.grey[100],
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: appSettings.adminToolsActive ? Colors.orange.shade300 : Colors.grey.shade300),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                appSettings.adminToolsActive ? Icons.timer : Icons.lock,
                                color: appSettings.adminToolsActive ? Colors.orange[800] : Colors.grey[700],
                                size: 20,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                appSettings.adminToolsActive
                                    ? 'Admin Tools aktiv (${appSettings.adminRemainingSeconds}s)'
                                    : 'Admin Tools freischalten',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: appSettings.adminToolsActive ? Colors.orange[900] : Colors.black87,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),

                          if (!appSettings.adminToolsActive) ...[
                            const Text(
                              'Passwort eingeben, um Notfall-Erstellung & Löschfunktionen für 3 Minuten freizuschalten:',
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
                                    final success = appSettings.unlockAdminMode(passwordController.text.trim());
                                    if (success) {
                                      TopBanner.show(
                                        context,
                                        message: 'Admin Tools für 3 Minuten freigeschaltet!',
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
                              'Admin Tools aktiv: Sie können jetzt Notfall-Events erstellen sowie lokale Einträge löschen.',
                              style: TextStyle(fontSize: 12, color: Colors.orange, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 10),
                            OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.red,
                                side: const BorderSide(color: Colors.red),
                                minimumSize: const Size(double.infinity, 40),
                              ),
                              onPressed: () => appSettings.disableAdminToolsManually(),
                              icon: const Icon(Icons.lock, size: 16),
                              label: const Text('Admin Tools sofort wieder sperren'),
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

  void _openAddEventDialog() {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    String selectedBlock = 'A';

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Dialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Notfall-Event anlegen',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: titleController,
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: 'Event-Titel (z.B. Sporttag 2026)',
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: descController,
                        decoration: InputDecoration(
                          hintText: 'Beschreibung (z.B. IT-Klassen)',
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                      const SizedBox(height: 12),

                      DropdownButtonFormField<String>(
                        value: selectedBlock,
                        decoration: InputDecoration(
                          labelText: 'Zugehöriger Block',
                          filled: true,
                          fillColor: Colors.grey[100],
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        ),
                        items: ['A', 'B', 'C'].map((b) {
                          return DropdownMenuItem(
                            value: b,
                            child: Text('Block $b', style: const TextStyle(fontWeight: FontWeight.bold)),
                          );
                        }).toList(),
                        onChanged: (val) {
                          if (val != null) {
                            setModalState(() => selectedBlock = val);
                          }
                        },
                      ),

                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Abbrechen', style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            onPressed: () {
                              if (titleController.text.trim().isNotEmpty) {
                                final newEvent = EventItem(
                                  id: DateTime.now().millisecondsSinceEpoch,
                                  title: 'LOCAL-${titleController.text.trim()}',
                                  description: descController.text.trim(),
                                  block: selectedBlock,
                                  date: DateTime.now(),
                                  isLocalOnly: true,
                                );
                                appSettings.addLocalEvent(newEvent);
                                Navigator.pop(context);
                              }
                            },
                            child: const Text('Hinzufügen & Aktivieren', style: TextStyle(fontWeight: FontWeight.bold)),
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

  void _confirmAndProceed() {
    appSettings.setBlockConfig(appSettings.activeEvent.block);
    appSettings.setActiveEventCode(appSettings.activeEvent.title);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const TeacherScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      floatingActionButton: FloatingActionButton.small(
        heroTag: 'eventHelpBtn',
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

                  // HEADER CHIP
                  Row(
                    children: [
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
                              Icon(Icons.emoji_events, color: Colors.orange, size: 16),
                              SizedBox(width: 4),
                              Text(
                                'Event wählen',
                                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.orange, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // SUCHLEISTE + ADD BUTTON + SETTINGS BUTTON
                  ListenableBuilder(
                    listenable: appSettings,
                    builder: (context, _) {
                      return Row(
                        children: [
                          Expanded(
                            child: TextField(
                              key: _searchKey,
                              onChanged: (val) => setState(() => searchQuery = val),
                              decoration: InputDecoration(
                                hintText: 'Event suchen...',
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

                          // ERSTELLEN BUTTON (NUR SICHTBAR WENN ADMIN TOOLS FREIGESCHALTET)
                          if (appSettings.canCreateEvent) ...[
                            SizedBox(
                              width: 48,
                              height: 48,
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
                                onPressed: _openAddEventDialog,
                                child: const Icon(Icons.add, size: 24),
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],

                          // SETTINGS BUTTON (IMMER DAS GEWOHNTE ZAHNRAD ICON BEIBEHALTEN)
                          SizedBox(
                            key: _settingsBtnKey,
                            width: 48,
                            height: 48,
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
                              onPressed: _openEventAdminSettings,
                              child: const Icon(Icons.settings, size: 22),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 12),

                  // LISTENLAYOUT
                  Expanded(
                    child: ListenableBuilder(
                      listenable: appSettings,
                      builder: (context, _) {
                        final activeEvent = appSettings.activeEvent;
                        final filteredHistory = appSettings.eventHistory
                            .where((e) =>
                        e.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
                            e.description.toLowerCase().contains(searchQuery.toLowerCase()))
                            .toList();

                        final showActive = activeEvent.title.toLowerCase().contains(searchQuery.toLowerCase()) ||
                            activeEvent.description.toLowerCase().contains(searchQuery.toLowerCase());

                        return ListView(
                          children: [
                            if (showActive) ...[
                              Card(
                                key: _activeEventKey,
                                color: Colors.orange[50],
                                margin: const EdgeInsets.symmetric(vertical: 4),
                                elevation: 2,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  side: const BorderSide(color: Colors.orange, width: 1.5),
                                ),
                                child: ListTile(
                                  onTap: _confirmAndProceed,
                                  leading: const Icon(Icons.emoji_events, color: Colors.orange, size: 28),
                                  title: Text(
                                    activeEvent.title,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                  ),
                                  subtitle: Text(
                                    '${activeEvent.description} • Block ${activeEvent.block}',
                                    style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.w600, fontSize: 12),
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      if (appSettings.canDeleteItems && activeEvent.isLocalOnly)
                                        IconButton(
                                          icon: const Icon(Icons.delete_outline, color: Colors.red, size: 22),
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (ctx) => AlertDialog(
                                                title: const Text('Aktives Event löschen?'),
                                                content: Text('Möchtest du das Notfall-Event "${activeEvent.title}" wirklich löschen?'),
                                                actions: [
                                                  TextButton(
                                                    onPressed: () => Navigator.pop(ctx),
                                                    child: const Text('Abbrechen'),
                                                  ),
                                                  ElevatedButton(
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor: Colors.red,
                                                      foregroundColor: Colors.white,
                                                    ),
                                                    onPressed: () {
                                                      Navigator.pop(ctx);
                                                      appSettings.addLocalEvent(
                                                        EventItem(
                                                          id: 1,
                                                          title: 'Sportfest 2026 - Block B',
                                                          description: 'Haupt-Sporttag der Jahrgänge 24, 25 und 26',
                                                          block: 'B',
                                                          date: DateTime(2026, 6, 18),
                                                          isLocalOnly: false,
                                                        ),
                                                      );
                                                      TopBanner.show(
                                                        context,
                                                        message: 'Notfall-Event gelöscht. Standard-Event wieder aktiv.',
                                                        backgroundColor: Colors.orange.shade800,
                                                        icon: Icons.delete_outline,
                                                      );
                                                    },
                                                    child: const Text('Löschen'),
                                                  ),
                                                ],
                                              ),
                                            );
                                          },
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Row(
                                children: [
                                  Expanded(child: Divider(thickness: 1)),
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Text('Vergangene Events (Historie)', style: TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.bold)),
                                  ),
                                  Expanded(child: Divider(thickness: 1)),
                                ],
                              ),
                              const SizedBox(height: 8),
                            ],

                            Container(
                              key: _historyKey,
                              child: Column(
                                children: filteredHistory.map((event) => Card(
                                  margin: const EdgeInsets.symmetric(vertical: 4),
                                  elevation: 1,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  child: ListTile(
                                    leading: const Icon(Icons.history, color: Colors.grey, size: 24),
                                    title: Text(event.title, style: const TextStyle(color: Colors.black87)),
                                    subtitle: Text(
                                      '${event.description} • Block ${event.block} • ${event.date.day}.${event.date.month}.${event.date.year}',
                                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                                    ),
                                    trailing: (appSettings.canDeleteItems && event.isLocalOnly)
                                        ? IconButton(
                                      icon: const Icon(Icons.delete_outline, color: Colors.red, size: 22),
                                      onPressed: () {
                                        appSettings.removeHistoryEvent(event);
                                        TopBanner.show(
                                          context,
                                          message: 'Lokales Event gelöscht!',
                                          backgroundColor: Colors.red.shade700,
                                          icon: Icons.delete_outline,
                                        );
                                      },
                                    )
                                        : null,
                                  ),
                                )).toList(),
                              ),
                            ),
                          ],
                        );
                      },
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
        currentKey = _activeEventKey;
        title = '1/4: Aktuelles Haupt-Event';
        description = 'Das ist das aktive Sportfest-Event vom Server. Tippen Sie einfach darauf, um direkt zur Lehrerwahl zu gelangen.';
        break;
      case 1:
        currentKey = _historyKey;
        title = '2/4: Event-Historie';
        description = 'Unter dem Trennbalken finden Sie alle vergangenen Sportfeste archiviert zur Information.';
        break;
      case 2:
        currentKey = _searchKey;
        title = '3/4: Event suchen';
        description = 'Nutzen Sie die Suchleiste, um schnell nach bestimmten Events oder Jahrgängen zu filtern.';
        break;
      case 3:
        currentKey = _settingsBtnKey;
        title = '4/4: Einstellungen & Admin-Tools';
        description = 'Über das Zahnrad-Symbol laden Sie neue Events vom Server oder schalten nach Admin-Passwort für 3 Minuten die Admin Tools frei.';
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
                                tutorialStep == 3 ? 'Fertig' : 'Weiter',
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
