Paperbound compile and audio hotfix (25 Nov 2026)

This patch replaces only:
  lib/main.dart
  lib/game_audio.dart

Changes:
- Corrects extra closing parentheses in PlayScreen HUD widget tree.
- Replaces a type-invalid Future.catchError callback with async try/catch for sound effects.

Install: Extract these two files into C:\Users\teera\Documents\mobile-paperplane, preserving lib/ and replacing existing files.
Keep all other game files and assets unchanged.

Then run:
  dart format lib/main.dart lib/game_audio.dart
  flutter analyze
  flutter test
  flutter run -d emulator-5554

No Flutter SDK available in the authoring environment; Android compile and runtime not verified here.
