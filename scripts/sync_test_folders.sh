#!/usr/bin/env bash

# Skript zum automatischen Spiegeln der Ordnerstruktur von lib/ nach test/unit/
echo "🔄 Spiegele Ordnerstruktur von lib/ nach test/unit/ ..."

# Core Unterordner spiegeln
for dir in lib/core/*/; do
  if [ -d "$dir" ]; then
    dirname=$(basename "$dir")
    mkdir -p "test/unit/core/$dirname"
    echo "✅ Ordner erstellt: test/unit/core/$dirname"
  fi
done

# Features Unterordner spiegeln
for dir in lib/features/*/; do
  if [ -d "$dir" ]; then
    feature_name=$(basename "$dir")
    mkdir -p "test/unit/features/$feature_name"
    echo "✅ Ordner erstellt: test/unit/features/$feature_name"
  fi
done

echo "✨ Fertig! Die Test-Ordnerstruktur wurde erfolgreich synchronisiert."
