import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/models/sport_event_model.dart';
import '../../../core/services/sport_event_store.dart';
import '../../../core/theme/app_colors.dart';

/// Seite zur Konfiguration und Verwaltung eines bestehenden Sportevents.
class ShowEventPage extends StatefulWidget {
  /// Das zu bearbeitende [SportEventModel].
  final SportEventModel event;

  /// Erstellt eine neue [ShowEventPage].
  const ShowEventPage({super.key, required this.event});

  @override
  State<ShowEventPage> createState() => _ShowEventPageState();
}

class _ShowEventPageState extends State<ShowEventPage> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late String _selectedBlock;

  // Auto-save state
  String _saveStatus = 'Automatisch gespeichert ✓';
  Timer? _debounceTimer;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.event.name);
    _descriptionController = TextEditingController(text: widget.event.description);
    _selectedBlock = widget.event.block;

    _nameController.addListener(_onFieldChanged);
    _descriptionController.addListener(_onFieldChanged);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _onFieldChanged() {
    setState(() {
      _saveStatus = 'Speichert...';
    });

    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 600), () {
      widget.event.name = _nameController.text;
      widget.event.description = _descriptionController.text;
      widget.event.block = _selectedBlock;
      SportEventStore().updateEvent(widget.event);

      if (mounted) {
        setState(() {
          _saveStatus = 'Automatisch gespeichert ✓';
        });
      }
    });
  }

  void _updateBlock(String block) {
    setState(() {
      _selectedBlock = block;
    });
    _onFieldChanged();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final filteredDisciplines = widget.event.disciplines.where((d) {
      return d.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          d.category.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('Event-Einstellungen'),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                _saveStatus,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // Kompakter Header (Side-by-Side on wide screens or Column on mobile)
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final isWide = constraints.maxWidth > 700;

                  final leftSection = Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Event Stammdaten',
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Name des Events',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.event),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _descriptionController,
                        maxLines: 2,
                        decoration: const InputDecoration(
                          labelText: 'Beschreibung (optional)',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.description),
                        ),
                      ),
                    ],
                  );

                  final rightSection = Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Block-Auswahl',
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: ['A', 'B', 'C'].map((block) {
                          final isSelected = _selectedBlock == block;
                          return Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: InkWell(
                                onTap: () => _updateBlock(block),
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(vertical: 16),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: isSelected ? colorScheme.primary : Colors.grey.shade100,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isSelected ? colorScheme.primary : Colors.grey.shade300,
                                    ),
                                  ),
                                  child: Text(
                                    'Block $block',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: isSelected ? Colors.white : Colors.black87,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  );

                  if (isWide) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: leftSection),
                        const SizedBox(width: 24),
                        Expanded(child: rightSection),
                      ],
                    );
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        leftSection,
                        const SizedBox(height: 24),
                        const Divider(),
                        const SizedBox(height: 16),
                        rightSection,
                      ],
                    );
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 28),

          // Disziplinen anpassen Sektion
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Disziplinen konfigurieren',
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text(
                '${widget.event.disciplines.where((d) => d.isEnabled).length} aktiv',
                style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Suchleiste
          TextField(
            onChanged: (val) => setState(() => _searchQuery = val),
            decoration: InputDecoration(
              hintText: 'Disziplinen durchsuchen...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
          ),
          const SizedBox(height: 16),

          // Grid für Disziplinen
          LayoutBuilder(
            builder: (context, constraints) {
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: filteredDisciplines.length,
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 320,
                  mainAxisExtent: 80,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                ),
                itemBuilder: (context, index) {
                  final discipline = filteredDisciplines[index];
                  Color badgeColor = AppColors.primary;
                  if (discipline.category == 'LAUF') badgeColor = AppColors.laufCategory;
                  if (discipline.category == 'SPRUNG') badgeColor = AppColors.sprungCategory;
                  if (discipline.category == 'WURF') badgeColor = AppColors.wurfCategory;

                  return Card(
                    elevation: 1,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: badgeColor.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(discipline.icon, color: badgeColor, size: 20),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                                  decoration: BoxDecoration(
                                    color: badgeColor.withValues(alpha: 0.15),
                                    borderRadius: BorderRadius.circular(3),
                                  ),
                                  child: Text(
                                    discipline.category,
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                      color: badgeColor,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  discipline.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13.5,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          Transform.scale(
                            scale: 0.85,
                            child: Switch(
                              value: discipline.isEnabled,
                              activeThumbColor: colorScheme.primary,
                              onChanged: (val) {
                                setState(() {
                                  discipline.isEnabled = val;
                                });
                                _onFieldChanged();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
