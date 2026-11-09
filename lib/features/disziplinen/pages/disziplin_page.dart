import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/models/discipline_model.dart';
import '../widgets/disziplin_card.dart';
import '../widgets/disziplin_dialog.dart';

/// Die Hauptseite zur Anzeige und Verwaltung aller Sportdisziplinen.
class DisziplinPage extends StatefulWidget {
  /// Optionale initiale Liste von Disziplinen (standardmäßig [DisciplineModel.defaultDisciplines()]).
  final List<DisciplineModel> disziplinen;

  /// Erstellt eine neue [DisziplinPage].
  const DisziplinPage({super.key, this.disziplinen = const []});

  @override
  State<DisziplinPage> createState() => _DisziplinPageState();
}

class _DisziplinPageState extends State<DisziplinPage> {
  late final List<DisciplineModel> _disziplinen;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _disziplinen = widget.disziplinen.isEmpty
        ? List.of(DisciplineModel.defaultDisciplines())
        : List.of(widget.disziplinen);
  }

  Future<void> _bearbeiten(int index) async {
    final originalDiscipline = filteredDisciplines[index];
    final originalIndex = _disziplinen.indexOf(originalDiscipline);

    final ergebnis = await showDialog<DisciplineModel>(
      context: context,
      barrierColor: Colors.black38,
      builder: (context) => DisziplinDialog(discipline: originalDiscipline),
    );

    if (ergebnis == null || !mounted) return;

    setState(() {
      _disziplinen[originalIndex] = ergebnis;
    });
  }

  Future<void> _hinzufuegen() async {
    final neueDisziplin = await showDialog<DisciplineModel>(
      context: context,
      barrierColor: Colors.black38,
      builder: (context) => const DisziplinDialog(),
    );

    if (neueDisziplin == null || !mounted) return;

    setState(() {
      _disziplinen.add(neueDisziplin);
    });
  }

  List<DisciplineModel> get filteredDisciplines {
    if (_searchQuery.trim().isEmpty) return _disziplinen;
    return _disziplinen
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
                    prefixIcon: const Icon(Icons.search, color: Colors.grey),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
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
                onPressed: _hinzufuegen,
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
              maxCrossAxisExtent: 330,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              mainAxisExtent: 175,
            ),
            itemCount: filteredDisciplines.length,
            itemBuilder: (context, index) {
              return DisziplinCard(
                discipline: filteredDisciplines[index],
                onTap: () => _bearbeiten(index),
              );
            },
          ),
        ),
        const SizedBox(height: 40),
      ],
    );
  }
}
