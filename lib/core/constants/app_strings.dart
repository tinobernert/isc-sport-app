/// Zentrale String-Konstanten der Anwendung (Standard: Deutsch).
/// Dient als Vorbereitung für eine spätere Mehrsprachigkeit (i18n).
abstract class AppStrings {
  static const String appName = 'SportPoint';
  static const String appSubtitle = 'Sportverwaltung';

  // Navigationstitel
  static const String mainPageTitle = 'Hauptseite';
  static const String rankingTitle = 'Punkteauswertung';
  static const String enterPointsTitle = 'Punkteeingabe';
  static const String createEventTitle = 'Veranstaltung erstellen';
  static const String disziplinenTitle = 'Disziplinen';
  static const String classesTitle = 'Klassen';
  static const String settingsTitle = 'Einstellungen';

  // Überschriften & Sektionen
  static const String rankingHeading = 'Rangliste';
  static const String createEventHeading = 'Veranstaltung';
  static const String activeEventSectionHeader = 'AKTUELLES EVENT';
  static const String archivedEventSectionHeader = 'ARCHIVIERTE EVENTS';
  static const String classesSectionHeader = 'KLASSEN';
  static const String eventMasterDataHeader = 'Event Stammdaten';
  static const String configureDisciplinesHeader = 'Disziplinen konfigurieren';
  static const String selectDisciplineTitle = 'Disziplin auswählen';
  static const String selectClassTitle = 'Klasse auswählen';
  static const String selectedDisciplineLabel = 'Gewählte Disziplin';

  // Status & Badges
  static const String activeStatusBadge = 'Aktiv';
  static const String autoSavedStatus = 'Automatisch gespeichert ✓';
  static const String savingStatus = 'Speichert...';

  // Suchhinweise
  static const String searchDisciplineHint = 'Disziplin suchen...';
  static const String searchDisciplinesHint = 'Disziplinen durchsuchen...';
  static const String searchClassHint = 'Klasse suchen...';

  // Platzhalter & Leer-Zustände
  static const String unnamedEvent = 'Unbenanntes Event';
  static const String noDescriptionText = 'Keine Beschreibung hinterlegt';
  static const String noActiveEventText = 'Kein aktives Event ausgewählt.';
  static const String noArchivedEventsText = 'Keine archivierten Events vorhanden.';
  static const String noActiveDisciplinesFound = 'Keine aktiven Disziplinen gefunden.';
  static const String noClassesFound = 'Keine Klassen gefunden.';

  // Dialoge & Aktionen
  static const String newEventButton = 'Neues Event';
  static const String addEventTitle = 'Neues Event anlegen';
  static const String eventDescriptionHint = 'Konfigurieren Sie das neue Sportfest für Ihre Berufsschulklassen.';
  static const String eventNameLabel = 'Name des Events';
  static const String eventDescLabel = 'Beschreibung (optional)';
  static const String eventDateLabel = 'Datum des Events';
  static const String blockSelectionLabel = 'Block-Auswahl';
  static const String cancelButton = 'Abbrechen';
  static const String createAndShowButton = 'Event anlegen & Anzeigen';
  static const String addDisciplineTitle = 'Disziplin hinzufügen';
  static const String editDisciplineTitle = 'Disziplin bearbeiten';
  static const String disciplineNameLabel = 'Name';
  static const String disciplineWeightLabel = 'Gewichtung';
  static const String iconLabel = 'Icon';
  static const String changeIconLabel = 'Icon ändern';
  static const String unitLabel = 'Einheit';
  static const String moreIsBetter = 'Mehr ist besser';
  static const String lessIsBetter = 'Weniger ist besser';
  static const String saveButton = 'Speichern';
}
