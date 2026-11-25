# Paper Plane - targeted rendering and HUD fix

This patch applies to the previously supplied FIXED game ZIP with the performance patch installed. It modifies only `lib/main.dart` and `lib/game.dart`.

Changes:
- Stop removing and recreating the Flutter HUD overlay every time a point is scored; a ValueNotifier updates only the score text.
- Cache building window rounded rectangles instead of constructing them on every rendered frame.
- Cache the paper-plane polygon path instead of allocating a new Path each frame.
- Render sky clouds and ground before the game components, not over them.

This patch has NOT been compiled or benchmarked in this environment (Flutter SDK unavailable). The emulator may remain slow due to GPU/virtualization configuration. It is not a guaranteed 60 FPS fix.

## Install
1. Stop `flutter run` with `q`.
2. Back up your existing `lib/main.dart` and `lib/game.dart`.
3. Extract this ZIP into your existing `mobile-paperplane` project root, replacing the two files.
4. Run:
   ```powershell
   dart format lib/main.dart lib/game.dart
   flutter analyze
   flutter test
   flutter run -d emulator-5554
   ```
5. If analyze or tests fail, restore the backups and report the error output.

For diagnosing emulator speed: open Android Studio Device Manager > Pixel 7 > Edit > Show Advanced Settings, ensure Graphics is Hardware/Automatic, then Cold Boot. Check Windows Task Manager > Performance > CPU > Virtualization: Enabled. Test a physical Android phone if possible to distinguish emulator slowness from game slowness.
