# Paperbound - Stable Music + 5 Skin Update

## Music stability
- Preloads BGM and SFX once.
- Serializes every BGM stop/play/volume operation through one queue.
- Prevents duplicate restart when the same stage track is already active.
- A new run intentionally restarts the Thailand theme from the beginning.
- Death still stops BGM through the existing game-over flow.

## Five presentation skins
1. Classic Skyfold - 0 m
2. Golden Temple - 10,000 m
3. Jade Wind - 20,000 m
4. Arcane Crystal - 30,000 m
5. Cosmic Voyager - 50,000 m

Unlocking uses saved best altitude, so unlocked skins remain available after closing the app. The selected skin is stored in SharedPreferences and is rendered in gameplay.
