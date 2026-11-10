import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/models/discipline_model.dart';
import '../widgets/discipline_card.dart';
import '../widgets/discipline_dialog.dart';

/// Die Hauptseite zur Anzeige und Verwaltung aller Sportdisziplinen.
class DisciplinePage extends StatefulWidget {
  /// Optionale initiale Liste von Disziplinen (standardmäßig [DisciplineModel.defaultDisciplines()]).
  final List<DisciplineModel> disciplines;

  /// Erstellt eine neue [DisciplinePage].
  const DisciplinePage({super.key, this.disciplines = const []});

  @override
  State<DisciplinePage> createState() => _DisciplinePageState();
}

class _DisciplinePageState extends State<DisciplinePage> {
  late final List<DisciplineModel> _disciplines;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _disciplines = widget.disciplines.isEmpty
        ? List.of(DisciplineModel.defaultDisciplines())
        : List.of(widget.disciplines);
  }

  Future<void> _edit(int index) async {
    final originalDiscipline = filteredDisciplines[index];
    final originalIndex = _disciplines.indexOf(originalDiscipline);

    final result = await showDialog<DisciplineModel>(
      context: context,
      barrierColor: Colors.black38,
      builder: (context) => DisciplineDialog(discipline: originalDiscipline),
    );

    if (result == null || !mounted) return;

    setState(() {
      _disciplines[originalIndex] = result;
    });
  }

  Future<void> _add() async {
    final newDiscipline = await showDialog<DisciplineModel>(
      context: context,
      barrierColor: Colors.black38,
      builder: (context) => const DisciplineDialog(),
    );

    if (newDiscipline == null || !mounted) return;

    setState(() {
      _disciplines.add(newDiscipline);
    });
  }

  List<DisciplineModel> get filteredDisciplines {
    if (_searchQuery.trim().isEmpty) return _disciplines;
    return _disciplines
        .where((d) => d.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        // Search & Add Bar Row
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  onChanged: (val) {
                    setState(() {
                      _searchQuery = val;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: 'Disziplin suchen...',
                    prefixIcon: const Icon(Icons.search, color: AppColors.grey500),
                    filled: true,
                    fillColor: AppColors.background,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColors.grey300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: AppColors.grey300),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: AppColors.primary),
                    ),
                    contentPadding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                onPressed: _add,
                icon: const Icon(Icons.add, size: 18),
                label: const Text('Hinzufügen', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        // Grid of Discipline Cards
        Expanded(
          child: filteredDisciplines.isEmpty
              ? const Center(
            child: Text('Keine Disziplinen gefunden.'),
          )
              : GridView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 320,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.45, // Proportionales Verhältnis für kompakte Höhe
            ),
            itemCount: filteredDisciplines.length,
            itemBuilder: (context, index) {
              return DisciplineCard(
                discipline: filteredDisciplines[index],
                onTap: () => _edit(index),
              );
            },
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}
