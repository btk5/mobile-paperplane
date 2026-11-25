import 'dart:async';
import 'package:flame_audio/flame_audio.dart';
import 'catalog.dart';

/// Single-owner audio controller. Music operations are serialized so menu,
/// gameplay and stage changes can never fight over the BGM player.
class GameAudio {
  bool sound = true;
  bool music = true;
  double soundVolume = .75;
  double musicVolume = .45;
  String? _track;
  final Map<String, DateTime> _last = {};
  Future<void> _musicQueue = Future<void>.value();
  bool _prepared = false;

  static const effects = <String>[
    'slash.wav',
    'kill.wav',
    'combo.wav',
    'thunder.wav',
    'wave.wav',
    'laser.wav',
    'leaf.wav',
    'orchid.wav',
    'shield.wav',
    'boss.wav',
    'crash.wav',
    'paper_tear.wav',
    'power.wav',
    'wind.wav',
  ];
  static const musicTracks = <String>[
    'music_menu.mp3',
    'music_china.wav',
    'music_mythical.wav',
    'music_space.wav',
  ];

  Future<void> prepare() async {
    if (_prepared) return;
    try {
      await FlameAudio.audioCache.loadAll([...effects, ...musicTracks]);
      _prepared = true;
    } catch (_) {
      // A missing/unsupported audio file must never break gameplay.
    }
  }

  void effect(String name, {int cooldownMs = 80}) {
    if (!sound) return;
    final now = DateTime.now();
    final last = _last[name];
    if (last != null && now.difference(last).inMilliseconds < cooldownMs)
      return;
    _last[name] = now;
    unawaited(_playEffect(name));
  }

  Future<void> _playEffect(String name) async {
    try {
      await FlameAudio.play('$name.wav', volume: soundVolume);
    } catch (_) {}
  }

  String _regionTrack(Region region) => switch (region) {
        Region.thailand => 'music_menu.mp3',
        Region.china => 'music_china.wav',
        Region.mythical => 'music_mythical.wav',
        Region.space => 'music_space.wav',
      };

  Future<void> _enqueue(Future<void> Function() action) {
    final next = _musicQueue.then((_) => action(), onError: (_) => action());
    _musicQueue = next.catchError((_) {});
    return next;
  }

  Future<void> _playTrack(String track, {bool restart = false}) =>
      _enqueue(() async {
        if (!music) {
          _track = null;
          try {
            await FlameAudio.bgm.stop();
          } catch (_) {}
          return;
        }
        await prepare();
        if (!restart && _track == track) {
          try {
            await FlameAudio.bgm.audioPlayer.setVolume(musicVolume);
          } catch (_) {}
          return;
        }
        try {
          await FlameAudio.bgm.stop();
          await FlameAudio.bgm.play(track, volume: musicVolume);
          _track = track;
        } catch (_) {
          _track = null;
        }
      });

  Future<void> stopMusic() => _enqueue(() async {
        _track = null;
        try {
          await FlameAudio.bgm.stop();
        } catch (_) {}
      });

  Future<void> playMenu() => _playTrack('music_menu.mp3');

  /// A new run intentionally starts the Thailand/menu theme from the beginning.
  Future<void> startRun() => _playTrack('music_menu.mp3', restart: true);

  Future<void> setRegion(Region region) => _playTrack(_regionTrack(region));

  Future<void> setMusic(bool enabled, Region region) async {
    music = enabled;
    if (!enabled) {
      await stopMusic();
    } else {
      await _playTrack(_regionTrack(region));
    }
  }

  Future<void> updateMusicVolume(double volume) => _enqueue(() async {
        musicVolume = volume.clamp(0.0, 1.0);
        try {
          await FlameAudio.bgm.audioPlayer.setVolume(musicVolume);
        } catch (_) {}
      });

  Future<void> dispose() => stopMusic();
}
