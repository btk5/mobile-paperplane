# Thailand Sprite & Sword-Slash Sound Update

This is a **complete overlay** based on Paperbound_Thailand_Combo_Real_Sprites_Music_COMPLETE.zip. It retains the uploaded menu MP3, existing stages, game logic and combo HUD.

## Updated
- Replaced 8 Thailand character animation sheets with original pixel-drawn recognizable silhouettes: Thai Kite (eyes and mouth), Golden Gecko (head, four legs, curled tail), Lantern Spirit (face), Tropical Hornbill (large bill, wings), Orchid Sprite (eyes and mouth), Storm Naga (coiled dragon head and horns), Golden Thunderbird (wide feathered wings), Monsoon Sky Serpent (larger storm dragon).
- Updated still images and bottom-left combo portrait images to match the new sheets.
- Replaced slash.wav and kill.wav with newly synthesized, punchier sword-swish and slash-impact sounds.
- All sheet frame dimensions/counts preserved so existing Flutter code can load them unchanged.

## Install
1. Back up your existing project **outside** mobile-paperplane.
2. Extract this ZIP over the project root, replacing matching files. Keep your existing android/ directory.
3. Run `flutter pub get`, `flutter analyze`, `flutter test`, `flutter run -d emulator-5554`.

## Notes
- These are genuine transparent PNG frame sheets (not conceptual mockups), made at small pixel dimensions with simple frame motion. They are not hand-painted high-detail sprite animations.
- Collision radius and logic are unchanged; visual shapes are improved but precise per-pixel hitboxes are not implemented.
- Not compiled or benchmarked with Flutter SDK in this environment. Validate on your emulator.
- The included user-supplied soundtrack may require permission before redistribution.
