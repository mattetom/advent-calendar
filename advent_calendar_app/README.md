# Advent Calendar App

Applicazione Flutter multipiattaforma per esplorare un calendario dell'avvento digitale con 24 caselle sbloccabili giorno per giorno. Ogni casella porta a contenuti dedicati, come video, immagini, playlist e minigiochi.

## Funzionalità principali

- **Layout responsivo** ottimizzato per smartphone e tablet tramite `responsive_builder` e `MediaQuery`.
- **Persistenza locale** dello stato delle caselle aperte con `shared_preferences`.
- **Navigazione dichiarativa** con `GoRouter` verso schermate di contenuto dedicate.
- **Test di widget e integrazione** per garantire il comportamento di sblocco e la corretta resa del calendario.

## Requisiti

- Flutter 3.13 o successivo.
- Dart SDK 3.0 o successivo.

## Avvio del progetto

```bash
flutter pub get
flutter run
```

## Esecuzione dei test

```bash
flutter test
flutter test integration_test
```

## Struttura del progetto

- `lib/main.dart`: entrypoint dell'applicazione e configurazione della navigazione.
- `lib/screens/`: schermate principali (`CalendarScreen` e `ContentScreen`).
- `lib/services/`: logica di business per il calendario e la persistenza.
- `lib/widgets/`: componenti riutilizzabili del calendario.
- `test/`: test di widget.
- `integration_test/`: test di integrazione che verifica la persistenza dello sblocco.

## Nota sui file di piattaforma

La struttura è compatibile con Android e iOS. Se necessario, rigenera i file di piattaforma con:

```bash
flutter create .
```

per assicurarti che i file nativi siano aggiornati all'ultima versione di Flutter installata localmente.
