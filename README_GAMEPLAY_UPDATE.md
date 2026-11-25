# Paperbound — Gameplay Tuning Update

Overlay for the existing `mobile-paperplane` Flutter project. This package includes the entire compatible Pixel Art overlay (not only a single Dart file).

Changes:
- Initial scrolling speed: 425 logical px/s; initial spawn interval: 0.88 s; maximum base speed: 720 logical px/s.
- Power mode: world scrolling and displayed altitude rate 2x normal speed.
- Power mode: automatic gentle horizontal weave; player taps remain active to switch lanes; magic shots remain automatic.
- Bottom-left latest manually defeated species and 1/3, 2/3, 3/3 progress. Defeating a different species resets progress to 1/3. Automatically cleared enemies do not affect this display.
- Settings: separate sound effects and music volume sliders, saved using shared_preferences. Live in-game music volume updates when game UI refreshes; settings are read at the start of a run.

## Install
1. Back up the project outside its root folder.
2. Extract this ZIP directly into the project root, overwriting matching files.
3. Move any old `*.backup.dart` or `paperbound_legacy_backup` folders OUTSIDE the project to prevent analyzer errors.
4. Run: `flutter pub get`, `dart format lib test`, `flutter analyze`, `flutter test`, `flutter run -d emulator-5554`.

## Verification
Static file checks only; Flutter SDK not available in the authoring environment. Compile, tests and performance on Android are UNVERIFIED. The existing Pixel Art package's other features remain unchanged.
