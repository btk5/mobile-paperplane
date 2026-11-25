# Paperbound - Original Audio and Magic Powers Overlay

This overlay replaces the previous Option A Flutter source in the existing `mobile-paperplane` root. It includes 4 original generated looping WAV music themes (Thailand, China, Mythical, Space), 13 original WAV effects, and automatic transformation attacks for all 37 species. The five requested Thai species use lightning (3), white shockwaves (4), long laser (1), leaf blades (5), and violet ricochet waves (5). Other species use data-driven attack patterns. Auto-defeated enemies do not advance combo. Music starts in gameplay and changes at the space transition; Sound/Music settings are read at the start of a run. Sound playback failures are nonfatal.

**IMPORTANT:** Flutter SDK was not available in the authoring environment. `flutter analyze`, `flutter test`, and Android playback are UNVERIFIED. Test before replacing your working version. Original generated audio is included in `assets/audio/` and listed in pubspec.

## Install (Windows)
1. Copy your current `mobile-paperplane` folder somewhere safe outside the project.
2. Extract this ZIP into `C:\Users\teera\Documents\mobile-paperplane`, replacing files.
3. Remove stale `*.backup.dart` from `lib/` and move `paperbound_legacy_backup/` outside the Flutter project if present.
4. Run `flutter pub get`, `dart format lib test`, `flutter analyze`, `flutter test`, `flutter run -d emulator-5554`.
5. If any compilation error appears, restore the backup and share the complete output.

## Limitations
These are original synthesized simple audio loops rather than professionally recorded instrument tracks. Visual powers are programmatic effects, not bespoke sprite animations. Attack shots target currently visible enemies; if none is present, they fire forward decoratively. Gameplay timing and sound mixing require device tuning.
