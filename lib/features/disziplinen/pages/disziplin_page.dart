import 'package:flutter/material.dart';

import '../../../core/navigation/app_routes.dart';
import '../../../core/widgets/add_button.dart';
import '../../../core/widgets/page_heading.dart';
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

  @override
  void initState() {
    super.initState();
    _disziplinen = widget.disziplinen.isEmpty
        ? List.of(DisciplineModel.defaultDisciplines())
        : List.of(widget.disziplinen);
  }

  Future<void> _bearbeiten(int index) async {
    final ergebnis = await showDialog<DisciplineModel>(
      context: context,
      barrierColor: Colors.black38,
      builder: (context) => DisziplinDialog(discipline: _disziplinen[index]),
    );

    if (ergebnis == null || !mounted) return;

    setState(() {
      _disziplinen[index] = ergebnis;
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

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 30),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              const Expanded(
                child: PageHeading(title: AppStrings.disziplinenTitle),
              ),
              const SizedBox(width: 16),
              AddButton(onPressed: _hinzufuegen),
            ],
          ),
        ),
        Expanded(
          child: GridView.builder(
            padding: const EdgeInsets.all(24),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 240,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              mainAxisExtent: 100,
            ),
            itemCount: _disziplinen.length,
            itemBuilder: (context, index) {
              return DisziplinCard(
                discipline: _disziplinen[index],
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
