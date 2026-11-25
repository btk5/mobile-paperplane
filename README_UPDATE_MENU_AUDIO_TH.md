# Paperbound — Menu & Audio Update

This is a full Flutter overlay based on Paperbound_Thailand_Character_Redesign_Sword_SFX_COMPLETE.zip.

Changes:
- Menu: animated paper-plane PNG, Thailand pixel-art background, monospaced arcade styling, and a fade/slide transition into gameplay.
- Gameplay: soundtrack restarts at the beginning of every run; stops immediately on fatal collision; restart starts it again.
- Death: newly synthesized paper-tearing sound (`assets/audio/paper_tear.wav`).
- Sword slash: removed from ordinary lane switching; plays on successful enemy defeat, including boss minions and enemies struck by magic.
- Retains uploaded menu soundtrack, Thailand stage, combo sprites, and existing gameplay.

Install: back up your existing project OUTSIDE its directory; extract this ZIP over your existing mobile-paperplane project. Keep your existing android/ directory. Remove old .dart backup files from inside the project if analyzer complains.

Run:
```
flutter pub get
flutter analyze
flutter test
flutter run -d emulator-5554
```

Not verified on a Flutter SDK in the generation environment. This is a source patch, not a guaranteed passing Android build. Soundtrack licensing must be reviewed before distribution.
