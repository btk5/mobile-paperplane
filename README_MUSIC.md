# Paperbound menu + gameplay music patch

This patch uses the user-supplied `Age of War - Theme Soundtrack.mp3` as `assets/audio/music_menu.mp3`.

- Menu: music starts when entering the app.
- Play: the same track restarts from the beginning when starting a run.
- Settings: existing music toggle and music volume slider are respected.
- The existing environment tracks remain in the project but are not selected by this patch.

## Installation

Extract into the existing `mobile-paperplane` project root and replace the files. Keep the existing `pubspec.yaml`, which must declare `assets/audio/` and depend on `flame_audio`. This patch targets the previously supplied Combo Icons & Menu Music version of `lib/main.dart`.

Run `flutter pub get`, `flutter analyze`, `flutter test`, then `flutter run -d emulator-5554`.

## Verification and rights

The MP3 is user supplied; its use and distribution rights have not been verified. Do not publish the game with this music without permission/license. Flutter/Android compilation and actual playback remain unverified in this environment.
