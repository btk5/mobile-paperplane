# Paperbound — Stage 1–3 / Black Outline / Pixel Smoke

This is a complete overlay for the existing `mobile-paperplane` Flutter project, based on the previous Pixel Menu / Thailand Boss version.

## Changes
- Player airplane PNGs (`plane_0` through `plane_7`) now have a 1-pixel dark outline; Thailand plane animation sheet is also outlined.
- Switching lanes emits capped, short-lived pixel smoke behind the airplane. Smoke does not alter collision or movement.
- Stage 1 always begins in Thailand; after 10,000m its boss must be defeated to advance to China, then Mythical, then Space. Score and altitude remain cumulative. These stage mechanics already existed in the base and are preserved.
- China and Mythical enemy definitions, sprites, backgrounds, regional bosses and powers are included, not placeholders for those regions. They use the same shared movement and combat system, so their behavior is not unique for every species.
- Import for GameWidget is explicit to avoid the Flame/Flutter Route name collision.
- Added stage progression regression tests.

## Install
Back up the whole existing project **outside** the project directory. Extract the contents of this ZIP directly into `C:\Users\teera\Documents\mobile-paperplane` and overwrite matching files. Move any old `*.backup.dart` or `paperbound_legacy_backup` folders outside the project so analyzer does not scan them.

```powershell
flutter pub get
dart format lib test
flutter analyze
flutter test
flutter run -d emulator-5554
```

## Verification
- PNGs and required region sprites are checked for presence and valid decoding.
- Source edited and regression tests written.
- Flutter SDK is unavailable here: **Flutter compilation, automated test execution, and Android FPS are UNVERIFIED**.
- This package preserves the existing gameplay architecture; unique hand-drawn animations for every China/Mythical creature are not included.
