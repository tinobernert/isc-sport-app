import 'dart:async';
import 'package:flutter/material.dart';
import '../../../../core/services/sport_event_store.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/models/sport_event_model.dart';

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
  late TextEditingController _dateController;
  late String _selectedBlock;
  late DateTime _selectedDate;
  late bool _isCurrent;

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
    _selectedDate = widget.event.date;
    _isCurrent = widget.event.isCurrent;
    _dateController = TextEditingController(
      text: '${_selectedDate.day}.${_selectedDate.month}.${_selectedDate.year}',
    );

    _nameController.addListener(_onFieldChanged);
    _descriptionController.addListener(_onFieldChanged);
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    _nameController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
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
      widget.event.date = _selectedDate;
      widget.event.isCurrent = _isCurrent;
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

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = '${picked.day}.${picked.month}.${picked.year}';
      });
      _onFieldChanged();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final filteredDisciplines = widget.event.disciplines.where((d) {
      return d.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          d.category.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    const warmBackgroundColor = Color(0xFFFCFBF9);
    const warmCardColor = Color(0xFFF4EFEA);

    return Scaffold(
      backgroundColor: warmBackgroundColor,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        title: Row(
          children: [
            const Text('Event-Einstellungen', style: TextStyle(fontWeight: FontWeight.bold)),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _saveStatus,
                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Colors.white),
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
            color: warmCardColor,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: BorderSide(color: AppColors.grey300.withValues(alpha: 0.5)),
            ),
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
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.black87),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          labelText: 'Name des Events',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: Icon(Icons.event),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: _descriptionController,
                        maxLines: 1,
                        maxLength: 50,
                        decoration: const InputDecoration(
                          labelText: 'Beschreibung (optional)',
                          border: OutlineInputBorder(),
                          filled: true,
                          fillColor: Colors.white,
                          prefixIcon: Icon(Icons.description),
                          counterText: '',
                        ),
                      ),
                    ],
                  );

                  final rightSection = Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Block-Auswahl',
                        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: Colors.black87),
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
                                    color: isSelected ? colorScheme.primary : Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isSelected ? colorScheme.primary : AppColors.grey300,
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
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: _dateController,
                              readOnly: true,
                              onTap: _pickDate,
                              decoration: const InputDecoration(
                                labelText: 'Datum des Events',
                                border: OutlineInputBorder(),
                                filled: true,
                                fillColor: Colors.white,
                                prefixIcon: Icon(Icons.calendar_today),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Container(
                            height: 56,
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(color: Colors.grey.shade400),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text(
                                  'Aktiv',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Colors.black87,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                Transform.scale(
                                  scale: 0.85,
                                  child: Switch(
                                    value: _isCurrent,
                                    activeThumbColor: colorScheme.primary,
                                    onChanged: (val) {
                                      setState(() {
                                        _isCurrent = val;
                                        if (val) {
                                          SportEventStore().setCurrentEvent(widget.event.id);
                                        } else {
                                          widget.event.isCurrent = false;
                                          SportEventStore().updateEvent(widget.event);
                                        }
                                      });
                                      _onFieldChanged();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
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
                        const Divider(color: AppColors.grey300),
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
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${widget.event.disciplines.where((d) => d.isEnabled).length} aktiv',
                  style: TextStyle(color: colorScheme.primary, fontWeight: FontWeight.bold),
                ),
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
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.grey300),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: AppColors.grey300),
              ),
              filled: true,
              fillColor: Colors.white,
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

                  return Card(
                    color: warmCardColor,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(color: AppColors.grey300.withValues(alpha: 0.5)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(discipline.icon, color: AppColors.primary, size: 20),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              discipline.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: Colors.black87,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
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
