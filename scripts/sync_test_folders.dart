import 'dart:io';

/// Skript zum automatischen Spiegeln der Ordnerstruktur von lib/ nach test/unit/
void main() {
  print('🔄 Spiegele Ordnerstruktur von lib/ nach test/unit/ ...\n');

  final libDir = Directory('lib');
  if (!libDir.existsSync()) {
    print('❌ Fehler: Ordner lib/ wurde nicht gefunden.');
    return;
  }

  // 1. Mirror core/ subdirectories (z. B. test/unit/core/models)
  final coreDir = Directory('lib/core');
  if (coreDir.existsSync()) {
    for (final entity in coreDir.listSync()) {
      if (entity is Directory) {
        final folderName = entity.path.split(Platform.pathSeparator).last;
        final target = Directory('test/unit/core/$folderName');
        target.createSync(recursive: true);
        print('✅ Ordner erstellt: ${target.path}');
      }
    }
  }

  // 2. Mirror features/ subdirectories (z. B. test/unit/features/create_event)
  final featuresDir = Directory('lib/features');
  if (featuresDir.existsSync()) {
    for (final entity in featuresDir.listSync()) {
      if (entity is Directory) {
        final featureName = entity.path.split(Platform.pathSeparator).last;
        final target = Directory('test/unit/features/$featureName');
        target.createSync(recursive: true);
        print('✅ Ordner erstellt: ${target.path}');
      }
    }
  }

  print('\n✨ Fertig! Die Test-Ordnerstruktur wurde erfolgreich synchronisiert.');
}
