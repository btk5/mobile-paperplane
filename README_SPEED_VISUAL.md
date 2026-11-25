# Paperbound - Faster Start & Side-Profile Enemies

This overlay is designed for the **Paperbound A Audio & Magic Powers** version, not the older Paper Plane game.

## Install
1. Stop the current game (`q` in the Flutter terminal).
2. Back up `lib/sky_game.dart` outside the Flutter project.
3. Extract this ZIP directly into the existing `mobile-paperplane` project root; replace `lib/sky_game.dart`.
4. Run:

```powershell
flutter pub get
dart format lib/sky_game.dart
flutter analyze
flutter test
flutter run -d emulator-5554
```

## Changes
- Initial visual scrolling speed: 240 -> 365 logical pixels/second.
- Maximum visual scrolling speed: 650 -> 670 logical pixels/second.
- Initial spawn interval: 1.45 -> 1.05 seconds (minimum 0.72 seconds).
- First spawn begins after 0.35 seconds.
- First obstacles delayed to 5,000 m for a more approachable opening.
- Enemies now render as colorful original side-profile cartoon flyers, with beaks facing toward the middle, animated wings, facial details, and special crests for elites. They are mirrored on the right lane.
- Preserves the existing audio, magic powers, combos, scores and settings.

## Verification
Source-level modifications and archive structure checked. Flutter/Dart SDK is not available in this build environment, so compilation, tests and device performance are **UNVERIFIED**. Run the commands above before using for submission.
