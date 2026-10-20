import 'package:flutter/material.dart';
import '../../../../core/config/app_settings.dart';
import '../../../../core/widgets/offline_banner.dart';
import '../../../event/presentation/screens/event_selection_screen.dart';
import '../../../school_class/presentation/screens/class_screen.dart';
import '../../../station/presentation/screens/station_screen.dart';
import '../../../teacher/presentation/screens/teacher_screen.dart';
import '../../domain/models/student.dart';

class ScoreEntryScreen extends StatefulWidget {
  final String teacherName;
  final String stationName;
  final String className;

  const ScoreEntryScreen({
    super.key,
    required this.teacherName,
    required this.stationName,
    required this.className,
  });

  @override
  State<ScoreEntryScreen> createState() => _ScoreEntryScreenState();
}

class _ScoreEntryScreenState extends State<ScoreEntryScreen> {
  String searchQuery = '';
  final appSettings = AppSettings();

  final Map<String, TextEditingController> _controllers = {};

  List<Student> students = [
    Student(id: '1', firstName: 'Tim', lastName: 'Becker'),
    Student(id: '2', firstName: 'Laura', lastName: 'Fischer'),
    Student(id: '3', firstName: 'Max', lastName: 'Schmidt'),
    Student(id: '4', firstName: 'Anna', lastName: 'Weber'),
  ];

  final List<List<Student>> _undoStack = [];
  final List<List<Student>> _redoStack = [];

  int? tutorialStep;

  final GlobalKey _headerEventKey = GlobalKey();
  final GlobalKey _headerTeacherKey = GlobalKey();
  final GlobalKey _headerStationKey = GlobalKey();
  final GlobalKey _headerClassKey = GlobalKey();
  final GlobalKey _searchKey = GlobalKey();
  final GlobalKey _undoRedoKey = GlobalKey();
  final GlobalKey _addBtnKey = GlobalKey();
  final GlobalKey _studentRowKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    for (var student in students) {
      _controllers[student.id] = TextEditingController(text: student.score);
    }
  }

  @override
  void dispose() {
    for (var controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  List<Student> _cloneStudentsList() {
    return students.map((s) => Student(
      id: s.id,
      firstName: s.firstName,
      lastName: s.lastName,
      status: s.status,
      score: s.score,
      isLocalOnly: s.isLocalOnly,
      isModified: s.isModified,
    )).toList();
  }

  void _saveSnapshot() {
    _undoStack.add(_cloneStudentsList());
    _redoStack.clear();
  }

  void _undo() {
    if (_undoStack.isNotEmpty) {
      _redoStack.add(_cloneStudentsList());
      final previousState = _undoStack.removeLast();
      setState(() {
        students = previousState;
        for (var s in students) {
          _controllers[s.id]?.text = s.score;
        }
      });
    }
  }

  void _redo() {
    if (_redoStack.isNotEmpty) {
      _undoStack.add(_cloneStudentsList());
      final nextState = _redoStack.removeLast();
      setState(() {
        students = nextState;
        for (var s in students) {
          _controllers[s.id]?.text = s.score;
        }
      });
    }
  }

  void _openAddStudentDialog() {
    final firstNameController = TextEditingController();
    final lastNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Schüler hinzufügen'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: firstNameController,
                autofocus: true,
                decoration: const InputDecoration(hintText: 'Vorname (z.B. Lukas)'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: lastNameController,
                decoration: const InputDecoration(hintText: 'Nachname (z.B. Meyer)'),
              ),
            ],
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
                final firstName = firstNameController.text.trim();
                final lastName = lastNameController.text.trim();
                if (firstName.isNotEmpty && lastName.isNotEmpty) {
                  _saveSnapshot();
                  final newId = DateTime.now().millisecondsSinceEpoch.toString();
                  final newStudent = Student(
                    id: newId,
                    firstName: firstName,
                    lastName: lastName,
                    isLocalOnly: true,
                  );
                  setState(() {
                    students.add(newStudent);
                    _controllers[newId] = TextEditingController(text: '');
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

  void _updateStatus(Student student, AttendanceStatus newStatus) {
    if (student.status != newStatus) {
      _saveSnapshot();
      setState(() {
        student.status = newStatus;
        student.isModified = true;

        if (newStatus == AttendanceStatus.excused) {
          student.score = '';
          _controllers[student.id]?.text = '';
        } else if (newStatus == AttendanceStatus.unexcused) {
          student.score = '0';
          _controllers[student.id]?.text = '0';
        }
      });
    }
  }

  void _onScoreChanged(Student student, String val) {
    if (student.score != val) {
      _saveSnapshot();
      setState(() {
        student.score = val;
        student.isModified = true;
      });
    }
  }

  void _startTutorial() {
    setState(() {
      tutorialStep = 0;
    });
  }

  void _nextTutorialStep() {
    setState(() {
      if (tutorialStep != null && tutorialStep! < 7) {
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

  @override
  Widget build(BuildContext context) {
    final filteredStudents = students.where((s) {
      final name = '${s.lastName} ${s.firstName}'.toLowerCase();
      return name.contains(searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F6),
      floatingActionButton: FloatingActionButton.small(
        heroTag: 'studentHelpBtn',
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

                  // HEADER CHIPS
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          key: _headerEventKey,
                          onTap: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => const EventSelectionScreen()),
                                  (route) => false,
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.emoji_events, color: Colors.orange, size: 14),
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

                      Expanded(
                        child: InkWell(
                          key: _headerTeacherKey,
                          onTap: () {
                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => const TeacherScreen()),
                                  (route) => false,
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.person, color: Colors.orange, size: 14),
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

                      Expanded(
                        child: InkWell(
                          key: _headerStationKey,
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => StationScreen(teacherName: widget.teacherName)),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.fitness_center, color: Colors.orange, size: 14),
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

                      Expanded(
                        child: InkWell(
                          key: _headerClassKey,
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ClassScreen(
                                  teacherName: widget.teacherName,
                                  stationName: widget.stationName,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.groups, color: Colors.orange, size: 14),
                                const SizedBox(width: 4),
                                Flexible(
                                  child: Text(
                                    widget.className,
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
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
                            hintText: 'Schüler suchen...',
                            prefixIcon: const Icon(Icons.search, color: Colors.orange),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 8),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        key: _undoRedoKey,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          children: [
                            IconButton(
                              icon: Icon(Icons.undo, color: _undoStack.isNotEmpty ? Colors.orange[800] : Colors.grey),
                              onPressed: _undoStack.isNotEmpty ? _undo : null,
                              tooltip: 'Rückgängig (Undo)',
                            ),
                            IconButton(
                              icon: Icon(Icons.redo, color: _redoStack.isNotEmpty ? Colors.orange[800] : Colors.grey),
                              onPressed: _redoStack.isNotEmpty ? _redo : null,
                              tooltip: 'Wiederholen (Redo)',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(
                        width: 48,
                        height: 48,
                        child: ElevatedButton(
                          key: _addBtnKey,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange[700],
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            padding: EdgeInsets.zero,
                          ),
                          onPressed: _openAddStudentDialog,
                          child: const Icon(Icons.add, size: 24),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),

                  // SCHÜLERLISTE (IMMER DER EINE STANDARD: NEUE SCHÜLER OBEN, REGULÄRE UNTEN)
                  Expanded(
                    child: _buildSeparateSectionList(filteredStudents),
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

  Widget _buildSeparateSectionList(List<Student> filteredStudents) {
    final newAddedStudents = filteredStudents.where((s) => s.isLocalOnly).toList()
      ..sort((a, b) => a.lastName.compareTo(b.lastName));

    final regularStudents = filteredStudents.where((s) => !s.isLocalOnly).toList()
      ..sort((a, b) => a.lastName.compareTo(b.lastName));

    return ListView(
      children: [
        if (newAddedStudents.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 6, top: 4),
            child: Row(
              children: [
                Icon(Icons.person_add, color: Colors.orange[800], size: 16),
                const SizedBox(width: 6),
                Text(
                  'Neu nachgetragene Schüler (${newAddedStudents.length})',
                  style: TextStyle(
                    color: Colors.orange[900],
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
          ...newAddedStudents.asMap().entries.map((entry) => _buildStudentCard(
            entry.value,
            isNewlyAdded: true,
            cardKey: entry.key == 0 ? _studentRowKey : null,
          )),
          const SizedBox(height: 10),
          const Row(
            children: [
              Expanded(child: Divider(thickness: 1, color: Colors.grey)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(
                  'Reguläre Schülerliste',
                  style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(child: Divider(thickness: 1, color: Colors.grey)),
            ],
          ),
          const SizedBox(height: 10),
        ],
        ...regularStudents.asMap().entries.map((entry) => _buildStudentCard(
          entry.value,
          isNewlyAdded: false,
          cardKey: (newAddedStudents.isEmpty && entry.key == 0) ? _studentRowKey : null,
        )),
      ],
    );
  }

  Widget _buildStudentCard(Student student, {required bool isNewlyAdded, Key? cardKey}) {
    final isModified = student.isModified;
    final isLocalOnly = student.isLocalOnly;

    return Card(
      key: cardKey,
      color: isNewlyAdded ? Colors.orange[50] : Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 4),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
        side: BorderSide(
          color: isNewlyAdded ? Colors.orange.shade300 : Colors.grey.shade200,
          width: isNewlyAdded ? 1.5 : 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
        child: Row(
          children: [
            Expanded(
              flex: 4,
              child: Row(
                children: [
                  SizedBox(
                    width: 24,
                    child: isNewlyAdded
                        ? Icon(Icons.add_circle, color: Colors.orange[800], size: 20)
                        : Icon(
                      (isLocalOnly || isModified) ? Icons.cloud_off : Icons.cloud_done,
                      color: (isLocalOnly || isModified) ? Colors.orange[800] : Colors.green[600],
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Flexible(
                    child: Text(
                      '${student.lastName}, ${student.firstName}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: isNewlyAdded ? Colors.orange[900] : Colors.black87,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 5,
              child: Align(
                alignment: Alignment.centerLeft,
                child: _buildStatusButtons(student),
              ),
            ),
            Expanded(
              flex: 2,
              child: Align(
                alignment: Alignment.centerLeft,
                child: _buildValueField(student),
              ),
            ),
            ListenableBuilder(
              listenable: appSettings,
              builder: (context, _) {
                if (appSettings.canDeleteItems && student.isLocalOnly) {
                  return SizedBox(
                    width: 60,
                    child: IconButton(
                      icon: const Icon(Icons.delete_outline, color: Colors.red, size: 22),
                      onPressed: () {
                        _saveSnapshot();
                        setState(() {
                          students.removeWhere((s) => s.id == student.id);
                        });
                      },
                    ),
                  );
                }
                return const SizedBox(width: 60);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusButtons(Student student) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _statusButton(
          label: 'Anwesend',
          isSelected: student.status == AttendanceStatus.present,
          activeColor: Colors.green,
          onTap: () => _updateStatus(student, AttendanceStatus.present),
        ),
        const SizedBox(width: 3),
        _statusButton(
          label: 'Entschuld.',
          isSelected: student.status == AttendanceStatus.excused,
          activeColor: Colors.orange[700]!,
          onTap: () => _updateStatus(student, AttendanceStatus.excused),
        ),
        const SizedBox(width: 3),
        _statusButton(
          label: 'Fehlt',
          isSelected: student.status == AttendanceStatus.unexcused,
          activeColor: Colors.red,
          onTap: () => _updateStatus(student, AttendanceStatus.unexcused),
        ),
      ],
    );
  }

  Widget _buildValueField(Student student) {
    return SizedBox(
      width: 65,
      height: 38,
      child: TextField(
        controller: _controllers[student.id],
        enabled: student.status == AttendanceStatus.present,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        decoration: InputDecoration(
          hintText: student.status == AttendanceStatus.present ? 'Wert' : '-',
          filled: true,
          fillColor: student.status == AttendanceStatus.present ? Colors.white : Colors.grey[100],
          contentPadding: const EdgeInsets.symmetric(horizontal: 2, vertical: 6),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
        ),
        onChanged: (val) => _onScoreChanged(student, val),
      ),
    );
  }

  Widget _statusButton({
    required String label,
    required bool isSelected,
    required Color activeColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? activeColor : Colors.grey[200],
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontSize: 10.5,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildSpotlightOverlay() {
    GlobalKey? currentKey;
    String title = '';
    String description = '';

    switch (tutorialStep) {
      case 0:
        currentKey = _headerEventKey;
        title = '1/8: Event wechseln';
        description = 'Klicken Sie auf den Event-Namen, um zur Event-Auswahl zurückzukehren.';
        break;
      case 1:
        currentKey = _headerTeacherKey;
        title = '2/8: Schritt 1 – Lehrkraft wählen';
        description = 'Falscher Lehrer ausgewählt? Klicken Sie hier, um die betreuende Lehrkraft jederzeit zu ändern.';
        break;
      case 2:
        currentKey = _headerStationKey;
        title = '3/8: Schritt 2 – Übung / Station wählen';
        description = 'Falsche Übung gewählt? Klicken Sie hier, um zu einer anderen Station zu wechseln.';
        break;
      case 3:
        currentKey = _headerClassKey;
        title = '4/8: Schritt 3 – Klasse wählen';
        description = 'Hier können Sie schnell zu einer anderen Klasse oder einem anderen Jahrgang wechseln.';
        break;
      case 4:
        currentKey = _searchKey;
        title = '5/8: Schritt 4 – Schüler suchen';
        description = 'Suchen Sie gezielt nach Namen, um die Liste sofort zu filtern.';
        break;
      case 5:
        currentKey = _undoRedoKey;
        title = '6/8: Schritt 5 – Rückgängig & Wiederholen';
        description = 'Ausversehen falsch geklickt? Mit den Pfeilen (Undo / Redo) machen Sie Ihre letzten Eingaben Schritt für Schritt rückgängig.';
        break;
      case 6:
        currentKey = _addBtnKey;
        title = '7/8: Schritt 6 – Schüler hinzufügen';
        description = 'Fehlt ein Schüler in der Liste? Über das Plus-Symbol tragen Sie neue Schüler schnell manuell nach.';
        break;
      case 7:
        currentKey = _studentRowKey;
        title = '8/8: Schritt 7 – Ergebniserfassung';
        description = 'Status (Anwesend/Entschuldigt/Fehlt) wählen und den Wert eintragen.';
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
                                tutorialStep == 7 ? 'Fertig' : 'Weiter',
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
