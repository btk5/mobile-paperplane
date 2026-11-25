# Paperbound Thailand Combo - Complete Integrated Overlay

Based on Paperbound_Boss_Dodge_Combo_Icons_Music_FIXED.zip (full integrated base).

Changes:
- Bottom-left 3 slots show the ACTUAL first frame from Thailand sprite sheets (Thai Kite, Golden Gecko, Lantern Spirit, Hornbill, Orchid, Naga, Thunderbird); other regions use their own existing enemy PNGs. No stars, generic icons, labels or enemy names in this HUD.
- The existing RunRules lastDefeatedId/lastDefeatedStreak controls the display: same species fills 1/2/3; a new species starts again at 1.
- User-provided Age of War soundtrack is included in assets/audio/music_menu.mp3, used on app menu and on Thailand gameplay start. China/Mythical/Space retain their existing stage music.
- Boss hazards remain dodge-only; boss charge is earned from defeating enemies, not obstacles.

Installation: back up your current project outside its root. Extract this ZIP over C:\Users\teera\Documents\mobile-paperplane, replacing files. Do not copy the folder paperbound_combo_complete itself as a nested folder.

Run:
flutter pub get
dart format lib test
flutter analyze
flutter test
flutter run -d emulator-5554

The archive and image dimensions have been checked, but Flutter SDK is unavailable in this build environment. Do not claim a successful Android build without testing on your machine.

Music rights: educational intent does not automatically authorize distribution of copyrighted music. Verify rights before sharing the APK or source assets.
