# Paperbound Character Redesign - China, Mythical, Space

This overlay is based on the Stage 1-3 black-outline/smoke build.

## Art direction
Thailand is the visual reference: dark pixel outlines, soft readable colors, clear creature silhouettes, visible faces where appropriate, and bosses with larger detailed forms.

## Replaced game sprites
China: Bamboo Sparrow, Festival Lantern, Paper Fox, Jade Butterfly, Cloud Carp, Crimson Dragon Whelp, Jade Storm Lion, Celestial Cloud Dragon.

Mythical: Crystal Bat, Mushroom Sprite, Fairy Wisp, Griffin Chick, Rune Orb, Phoenix Ember, Void Mimic, Arcane Sky Kraken.

Space: UFO Scout, Cosmic Jellyfish, Meteor Mite, Astro Beetle, Plasma Sprite, Orbit Eye, Gravity Slime, Nebula Moth, Quantum Phantom, Star Eel, Cosmic Leviathan, Nebula Overlord, The Singularity.

The corresponding assets/images/combo sprites are replaced too, so the bottom-left combo display matches the enemies in gameplay.

## Install
Extract this ZIP over the current project root, then run:

flutter pub get
dart format lib test
flutter analyze
flutter test
flutter run -d emulator-5554

## Verification
The ZIP structure and all redesigned PNG files were checked in the generation environment. Flutter SDK was not available here, so Android compilation remains to be verified locally.
