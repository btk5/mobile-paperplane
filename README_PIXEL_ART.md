# Paperbound: Beyond the Sky — Pixel Art Edition

This overlay is designed to be extracted into the existing `mobile-paperplane` Flutter project root. It combines the previous audio/magic-powers update and faster-start update, rather than relying on mismatched partial patches.

## Included

- 37 individually named enemy/boss pixel sprites (generated original assets, with distinct silhouettes for major creature families)
- 8 paper-plane rotation frames
- 4 soft-palette regional backgrounds (Thailand, China, Mythical, Space)
- 17 original synthesized WAV music/effects assets
- Flutter/Flame gameplay, combo/powers, save system, tests, and asset registration
- Cached image loading and nearest-neighbor sprite drawing

## Installation

1. Back up your entire current project outside its root.
2. Extract this ZIP into `C:\Users\teera\Documents\mobile-paperplane`, replacing matching files.
3. Run `powershell -ExecutionPolicy Bypass -File .\REMOVE_LEGACY_FILES.ps1` to archive legacy Dart backups OUTSIDE the project.
4. Run `flutter pub get`, `dart format lib test`, `flutter analyze`, `flutter test`, and `flutter run -d emulator-5554`.
5. Stop and inspect any compiler errors before continuing.

## Verification and limitations

The ZIP, file references, sprite count and audio asset presence were checked in the authoring environment. Flutter/Dart SDK is not installed here, so compilation, Android runtime, audio playback and measured FPS are **UNVERIFIED**.

The pixel artwork is original programmatically drawn sprite art, not a reproduction of linked reference images. Enemy families have varied silhouettes, but 37 fully hand-animated unique sprite sheets and 37 fully differentiated transformations remain outside this update. Bosses have distinct enlarged sprites but no bespoke multi-frame boss animation yet. Power VFX are rendered by the existing Flame Canvas effect system, with included SFX.

The generated visual concept reference image is an inspiration preview, not an asset used by the game.
