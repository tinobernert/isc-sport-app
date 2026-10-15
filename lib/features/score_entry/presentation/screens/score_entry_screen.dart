import 'package:flutter/material.dart';
import '../../../../core/widgets/offline_banner.dart';
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

  final Map<String, TextEditingController> _controllers = {};

  List<Student> students = [
    Student(id: '1', firstName: 'Tim', lastName: 'Becker'),
    Student(id: '2', firstName: 'Laura', lastName: 'Fischer'),
    Student(id: '3', firstName: 'Max', lastName: 'Schmidt'),
    Student(id: '4', firstName: 'Anna', lastName: 'Weber'),
  ];

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

  void _updateStatus(Student student, AttendanceStatus newStatus) {
    setState(() {
      student.status = newStatus;
      if (newStatus == AttendanceStatus.excused) {
        student.score = '';
        _controllers[student.id]?.text = '';
      } else if (newStatus == AttendanceStatus.unexcused) {
        student.score = '0';
        _controllers[student.id]?.text = '0';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final filteredStudents = students.where((s) {
      final name = '${s.lastName} ${s.firstName}'.toLowerCase();
      return name.contains(searchQuery.toLowerCase());
    }).toList()
      ..sort((a, b) => a.lastName.compareTo(b.lastName));

    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F6),
      body: SafeArea(
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
                  const SizedBox(width: 6),
                  Expanded(
                    child: InkWell(
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
              TextField(
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
              const SizedBox(height: 12),
              Expanded(
                child: ListView.builder(
                  itemCount: filteredStudents.length,
                  itemBuilder: (context, index) {
                    final student = filteredStudents[index];

                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: Colors.grey.shade200),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 4,
                              child: Text(
                                '${student.lastName}, ${student.firstName}',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: Center(
                                child: _buildStatusButtons(student),
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: _buildValueField(student),
                              ),
                            ),
                          ],
                        ),
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
        const SizedBox(width: 4),
        _statusButton(
          label: 'Entschuld.',
          isSelected: student.status == AttendanceStatus.excused,
          activeColor: Colors.orange[700]!,
          onTap: () => _updateStatus(student, AttendanceStatus.excused),
        ),
        const SizedBox(width: 4),
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
      width: 70,
      height: 40,
      child: TextField(
        controller: _controllers[student.id],
        enabled: student.status == AttendanceStatus.present,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        decoration: InputDecoration(
          hintText: student.status == AttendanceStatus.present ? 'Wert' : '-',
          filled: true,
          fillColor: student.status == AttendanceStatus.present ? Colors.white : Colors.grey[100],
          contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(6),
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
        ),
        onChanged: (val) {
          student.score = val;
        },
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
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
        decoration: BoxDecoration(
          color: isSelected ? activeColor : Colors.grey[200],
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontSize: 11,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
