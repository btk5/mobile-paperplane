# Paperbound: Boss Dodge + Icon Combo + Restored Music

- Boss obstacles are dodge-only. They never charge the combo or fire boss attacks.
- Defeat three identical boss minions to remove one boss HP segment.
- Boss waves spawn three matching enemies then one rock to dodge.
- Bottom-left combo HUD displays only enemy sprite icons (up to three), no stars or text.
- The user-supplied music_menu.mp3 plays on the main menu and restarts on Thailand gameplay. Other regions keep their original theme music.
- Existing gameplay, saved progress and Android emulator configuration remain unchanged.

Install by extracting this ZIP into the **existing** mobile-paperplane root, replacing matching files. Back up the project outside its root first.

```powershell
flutter pub get
dart format lib test
flutter analyze
flutter test
flutter run -d emulator-5554
```

Do not redistribute the user-supplied soundtrack without appropriate permission.

This ZIP has been structurally checked but not Flutter-compiled in this environment.
