# 🏆 SportPoint - Sportverwaltung App

**SportPoint** ist eine moderne Flutter-Anwendung zur einfachen Verwaltung und Auswertung von Sportfesten und Wettkämpfen an Berufsschulen.

---

## 📑 Inhaltsverzeichnis
- [Features](#-features)
- [App-Architektur](#-app-architektur)
- [Testing & Test-Struktur](#-testing--test-struktur)
- [Test-Ordner automatisch synchronisieren](#-test-ordner-automatisch-synchronisieren)
- [Projekt starten](#-projekt-starten)

---

## ✨ Features

- **Veranstaltung verwalten**:
  - Aktives Event festlegen und bearbeiten (Name, einzeilige Beschreibung, Datum-Picker, Block-Auswahl A/B/C, Aktiv-Toggle).
  - Archivierte Events übersichtlich einsehen.
  - Disziplinen flexibel aktivieren oder deaktivieren.
- **Disziplinen**:
  - Übersicht aller Sportdisziplinen mit Einheit (`unit`), Gewichtung (`weight`) und Auswertung (`higherIsBetter`).
  - Suchen und Anpassen von Disziplinen.
- **Punkteeingabe & Auswertung**:
  - Geführter Ablauf: Disziplin wählen ➔ Klasse wählen ➔ Schüler-Ergebnisse erfassen.
  - Automatische Ranglisten- und Punkteberechnung.

---

## 🏗️ App-Architektur

Das Projekt folgt strikt dem **Feature-First Architecture**-Standard in Kombination mit **Clean Architecture**-Prinzipien.

```text
lib/
├── core/                         <-- Globale Infrastruktur (Theme, Navigation, Core-Widgets)
│   ├── constants/
│   ├── navigation/
│   ├── theme/
│   └── widgets/
│
└── features/                     <-- Fachliche Features
    └── <feature_name>/
        ├── domain/               <-- Geschäftslogik & Datenmodelle (z. B. SportEventModel)
        ├── data/                 <-- DataSources & Repositories
        └── presentation/         <-- UI (Pages, Controllers, Widgets)
```

---

## 🧪 Testing & Test-Struktur

Die Test-Struktur unter `test/unit/` spiegelt die Ordnerstruktur aus `lib/` wider:

```text
test/
└── unit/
    ├── core/                     <-- Tests für globale Services & Core-Models
    │   └── discipline_model_test.dart
    │
    └── features/                 <-- Tests pro Feature
        └── create_event/
            ├── sport_event_model_test.dart
            └── sport_event_store_test.dart
```

### Tests ausführen
Um alle Unit-Tests im Terminal auszuführen:
```bash
flutter test
```

---

## 🔄 Test-Ordner automatisch synchronisieren

Wenn neue Features oder Core-Ordner in `lib/` dazukommen, kannst du die Ordnerstruktur unter `test/unit/` automatisch mit einem einzigen Befehl spiegeln:

```bash
./scripts/sync_test_folders.sh
```

**Was macht das Skript?**
- Liest alle Ordner unter `lib/core/` und `lib/features/` aus.
- Erstellt automatisch die entsprechenden Test-Unterordner unter `test/unit/core/` und `test/unit/features/<feature_name>/`.

---

## 🚀 Projekt starten

1. **Abhängigkeiten installieren:**
   ```bash
   flutter pub get
   ```

2. **App im Entwicklungsmodus starten:**
   ```bash
   flutter run
   ```
