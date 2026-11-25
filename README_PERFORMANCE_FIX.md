# Paper Plane - Performance Patch (experimental)

This patch replaces only `lib/game.dart` and `lib/audio.dart`.

Changes:
- Reuses Paint objects instead of allocating new ones on each frame.
- Throttles rapid overlapping flap sound playback.
- Avoids starting background music repeatedly when it is already playing.
- Keeps gameplay rules, SQLite database, unlocks, and screen navigation unchanged.

## Install
1. Back up the existing project, or commit a local checkpoint.
2. Extract this ZIP into the existing Flutter project root, replacing the two Dart files.
3. Run `dart format lib/game.dart lib/audio.dart`.
4. Run `flutter analyze` and `flutter test`.
5. Run `flutter run -d emulator-5554`.
6. Compare performance with Sound and Music disabled and enabled.

## Verification
Static source transformations only. Flutter SDK was not available in the packaging environment. Compilation, automated tests, and frame timing on your emulator remain **UNVERIFIED**.

If performance remains poor, use Flutter DevTools Performance to determine whether the bottleneck is CPU/UI, rasterization, emulator graphics acceleration, or audio. Do not assume this patch guarantees 60 FPS.
