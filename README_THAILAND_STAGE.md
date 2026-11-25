# Paperbound: Thailand-first sequential stages

This package is a **complete source overlay**, not a standalone Flutter SDK project. Preserve your existing `android/` directory and install on top of your `mobile-paperplane` project.

## New gameplay
- Every new run begins in Thailand. The former random-world Play button is replaced.
- At **10,000 m**, Monsoon Sky Serpent appears. Altitude and score continue to increase while fighting.
- Boss shows a 3-segment HP bar and releases alternating left/right enemy or falling-rock waves.
- During the encounter, use Paper Slash to defeat **three consecutive identical targets** (same species or three falling rocks). Each completed trio triggers a magic strike and removes **one boss HP**.
- The boss requires three successful trios (9 matching defeats minimum). Different targets reset the current 3-hit counter.
- Boss defeat advances Thailand -> China -> Mythical -> Space, keeping score and altitude. Each of the first three regions has a 10,000 m stage distance and a boss gate.
- Thailand boss waves are forgiving; later regions are less forgiving. Normal gameplay, combos, shields, audio and saved high scores remain in place.
- The Thailand character sheets from the earlier Sprite Assets package are wired into Flame rendering (13 sheets). These are the earlier simple assets, **not** the newly proposed detailed character redesign. That redesign still needs real separate artwork.

## Install
1. Stop the running game (`q`). Copy the entire current project to a backup folder OUTSIDE the project.
2. Extract this ZIP into `C:\Users\teera\Documents\mobile-paperplane`, choosing Replace.
3. In the project terminal, run:

```powershell
powershell -ExecutionPolicy Bypass -File .\REMOVE_LEGACY_FILES.ps1
flutter pub get
dart format lib test
flutter analyze
flutter test
flutter run -d emulator-5554
```

This archive is assembled and statically inspected, but **Flutter SDK is not installed in the build environment**; Android compilation, tests and gameplay FPS must be verified on your PC. Existing Android project files are not replaced.

## Notes
- Stage progression is intentionally different from the old master prompt's random start and 100,000 m space transition, following the new user request.
- In-game HUD still includes earlier combo UI; boss has a dedicated 3-target counter.
- Space uses the pre-existing endless encounter behavior; dedicated recurring space boss fights are not implemented by this patch.
