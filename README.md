# Paperbound: Beyond the Sky — Option A development build

This Flutter + Flame **Android overlay** replaces the earlier Paper Plane gameplay. It uses the existing `mobile_paperplane` package name, Android project, and Pixel 7 emulator. It is **not** a completed production release.

## Install

1. Back up your current `mobile-paperplane` folder (copy the entire directory).
2. Extract this ZIP **into the project root**, replacing files. Do not extract as a nested folder.
3. Run `powershell -ExecutionPolicy Bypass -File .\REMOVE_LEGACY_FILES.ps1` to back up and remove unused Dart files from the earlier game.
4. Run:

```powershell
flutter pub get
dart format lib test
flutter analyze
flutter test
flutter run -d emulator-5554
```

The project uses Flutter Material, Flame, Provider and SharedPreferences. **Keep your existing Android folder**. On a new machine, generate the standard platform files using Flutter before applying the overlay.

## Implemented in this development build

- Two-lane upward flight, timed crossing, basic automatic slash, altitude progression and space transition.
- Regional random start and practice selection; 37 data-driven enemy/boss definitions.
- Combo of three same-species defeats; temporary powers with configurable timing tiers.
- One-hit damage, one-use shield, basic 3-hit boss encounter and recovery window.
- Basic procedural encounters, animated procedural scenery and particles.
- Persistent best altitude, top ten, collection discovery, encounter/defeat/power counts, cosmetic selection and achievements.
- 12 cosmetic color variants, pause, retry, scores, encyclopedia and settings UI.
- Additional unit tests for combo rules, catalog counts, unlock tiers, shields and space transition.

## Important limitations

- The full 37 distinct enemy illustrations, animations, behavior archetypes and transformation appearances are **not implemented**.
- Bosses currently share a basic movement/rendering system, not six distinct polished encounters.
- No bundled soundtrack or sound effects; the settings toggles are placeholders.
- No verified swept collision, spawn solvability proof, 5-minute space balancing, GPU profiling, or 60 FPS guarantee.
- Flutter/Android SDK was not available in the generation environment. Compilation and tests **must be run locally**.
- Existing saved progress is keyed with `pb_` keys and may persist when updating this overlay.

## Troubleshooting

If `flutter analyze` reports errors, **do not push or submit**. Keep the terminal output and correct those errors before running. Run `flutter devices` if the emulator ID changes. The previous game is restorable from your full-folder backup.

## Credits

Original procedural drawings and game logic. No proprietary media from the linked video is bundled. This is a Flutter adaptation of the supplied game design prompt, not a Phaser/PWA implementation.
