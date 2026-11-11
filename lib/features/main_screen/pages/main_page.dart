import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/models/discipline_model.dart';
import '../../../core/services/sport_event_store.dart';
import '../../../core/theme/app_colors.dart';
import 'class_selection_page.dart';

/// Die Hauptseite (Dashboard) der Anwendung zur Disziplinauswahl.
class MainPage extends StatefulWidget {
  /// Erstellt eine neue [MainPage].
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final SportEventStore _store = SportEventStore();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _store.addListener(_onStoreChanged);
  }

  @override
  void dispose() {
    _store.removeListener(_onStoreChanged);
    super.dispose();
  }

  void _onStoreChanged() {
    if (mounted) setState(() {});
  }

  List<DisciplineModel> get _availableDisciplines {
    final currentEvent = _store.currentEvent;
    if (currentEvent != null) {
      return currentEvent.disciplines.where((d) => d.isEnabled).toList();
    }
    return DisciplineModel.defaultDisciplines();
  }

  List<DisciplineModel> get _filteredDisciplines {
    if (_searchQuery.trim().isEmpty) return _availableDisciplines;
    return _availableDisciplines
        .where((d) => d.name.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();
  }

  void _selectDiscipline(DisciplineModel discipline) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ClassSelectionPage(discipline: discipline),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final activeEvent = _store.currentEvent;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 24),

          // Header Bereich (Event Info)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Disziplin auswählen',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  activeEvent != null
                      ? 'Aktuelles Event: ${activeEvent.name} (Block ${activeEvent.block})'
                      : 'Wählen Sie eine Disziplin aus, um mit der Punkteeingabe zu starten.',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Suchleiste
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
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
          const SizedBox(height: 20),

          // Kompaktes Grid der Disziplinen
          Expanded(
            child: _filteredDisciplines.isEmpty
                ? const Center(
                    child: Text(
                      'Keine aktiven Disziplinen gefunden.',
                      style: TextStyle(color: AppColors.textMuted),
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                      maxCrossAxisExtent: 320,
                      mainAxisExtent: 110,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: _filteredDisciplines.length,
                    itemBuilder: (context, index) {
                      final discipline = _filteredDisciplines[index];
                      return Card(
                        color: AppColors.background,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(color: AppColors.grey300, width: 1.2),
                        ),
                        child: InkWell(
                          onTap: () => _selectDiscipline(discipline),
                          borderRadius: BorderRadius.circular(16),
                          child: Padding(
                            padding: const EdgeInsets.all(14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Icon & Title Row
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        color: AppColors.primaryLight,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Icon(
                                        discipline.icon,
                                        color: AppColors.primary,
                                        size: 18,
                                      ),
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        discipline.name,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: AppColors.grey800,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                // Nur Beschreibung (kompakt 2 Zeilen)
                                Text(
                                  discipline.description,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    height: 1.25,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.grey600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
