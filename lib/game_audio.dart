import 'dart:async';
import 'package:flame_audio/flame_audio.dart';
import 'catalog.dart';

/// Sounds are original generated WAVs. Errors must never interrupt gameplay.
class GameAudio {
  bool sound = true;
  bool music = true;
  double soundVolume = .75;
  double musicVolume = .45;
  String? _track;
  final Map<String, DateTime> _last = {};
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

  Future<void> prepare() async {
    try {
      await FlameAudio.audioCache.loadAll(effects);
    } catch (_) {}
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
    } catch (_) {
      // Audio failures must not interrupt the game loop.
    }
  }

  String _regionTrack(Region region) => switch (region) {
        Region.thailand => 'music_menu.mp3',
        Region.china => 'music_china.wav',
        Region.mythical => 'music_mythical.wav',
        Region.space => 'music_space.wav',
      };

  Future<void> stopMusic() async {
    _track = null;
    try {
      await FlameAudio.bgm.stop();
    } catch (_) {}
  }

  Future<void> playMenu() async {
    _track = null;
    if (!music) {
      await stopMusic();
      return;
    }
    try {
      await FlameAudio.bgm.stop();
      await FlameAudio.bgm.play('music_menu.mp3', volume: musicVolume);
      _track = 'music_menu.mp3';
    } catch (_) {}
  }

  Future<void> startRun() async {
    // Always restart the soundtrack from the beginning on a new run.
    _track = null;
    if (!music) {
      await stopMusic();
      return;
    }
    try {
      await FlameAudio.bgm.stop();
      await FlameAudio.bgm.play('music_menu.mp3', volume: musicVolume);
      _track = 'music_menu.mp3';
    } catch (_) {}
  }

  Future<void> setRegion(Region region) async {
    final next = _regionTrack(region);
    if (_track == next) return;
    _track = next;
    if (!music) return;
    try {
      await FlameAudio.bgm.stop();
      await FlameAudio.bgm.play(next, volume: musicVolume);
    } catch (_) {}
  }

  Future<void> setMusic(bool enabled, Region region) async {
    music = enabled;
    _track = null;
    if (!enabled) {
      try {
        await FlameAudio.bgm.stop();
      } catch (_) {}
    } else {
      await setRegion(region);
    }
  }

  Future<void> updateMusicVolume(double volume) async {
    musicVolume = volume.clamp(0.0, 1.0);
    try {
      await FlameAudio.bgm.audioPlayer.setVolume(musicVolume);
    } catch (_) {}
  }

  Future<void> dispose() async {
    try {
      await FlameAudio.bgm.stop();
    } catch (_) {}
    _track = null;
  }
}
