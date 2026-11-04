import 'package:flutter/material.dart';

import '../../../core/navigation/app_routes.dart';
import '../../../core/widgets/add_button.dart';
import '../../../core/widgets/page_heading.dart';
import '../data/test_disziplinen.dart';
import '../models/disziplin.dart';
import '../widgets/disziplin_card.dart';
import '../widgets/disziplin_dialog.dart';

/// Die Hauptseite zur Anzeige und Verwaltung aller Sportdisziplinen.
class DisziplinPage extends StatefulWidget {
  /// Optionale initiale Liste von Disziplinen (standardmäßig [testDisziplinen]).
  final List<Disziplin> disziplinen;
  /// Erstellt eine neue [DisziplinPage].
  const DisziplinPage({super.key, this.disziplinen = testDisziplinen});

  @override
  State<DisziplinPage> createState() => _DisziplinPageState();
}

class _DisziplinPageState extends State<DisziplinPage> {
  // Eigene Kopie, damit die ursprüngliche Testliste unverändert bleibt.
  late final List<Disziplin> _disziplinen;

  @override
  void initState() {
    super.initState();
    _disziplinen = List.of(widget.disziplinen);
  }

  Future<void> _bearbeiten(int index) async {
    final ergebnis = await showDialog<Disziplin>(
      context: context,
      barrierColor: Colors.black38,
      builder: (context) => DisziplinDialog(disziplin: _disziplinen[index]),
    );

    if (ergebnis == null || !mounted) return;

    // Vorhandenen Eintrag durch die bearbeitete Disziplin ersetzen.
    setState(() {
      _disziplinen[index] = ergebnis;
    });
  }

  Future<void> _hinzufuegen() async {
    final neueDisziplin = await showDialog<Disziplin>(
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
                child: PageHeading(title: 'Disziplinen verwalten'),
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
              maxCrossAxisExtent: 220,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              mainAxisExtent: 100,
            ),
            itemCount: _disziplinen.length,
            itemBuilder: (context, index) {
              return DisziplinCard(
                disziplin: _disziplinen[index],
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
