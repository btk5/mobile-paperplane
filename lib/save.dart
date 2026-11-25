import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'catalog.dart';
import 'rules.dart';

class SaveData extends ChangeNotifier {
  SharedPreferences? _prefs;
  int best = 0, runs = 0, selectedSkin = 0;
  bool sound = true, music = true;
  double soundVolume = .75, musicVolume = .45;
  final Set<String> discovered = {};
  final Map<String, int> defeats = {}, encounters = {}, powerUses = {};
  final List<int> highs = [];
  int totalKills = 0, totalBosses = 0, totalTransformations = 0;
  final Set<String> achievements = {};
  static const skinMilestones = [
    0,
    1500,
    5000,
    12000,
    25000,
    50000,
    100000,
    250000,
    500000,
    1000000,
    2500000,
    10000000
  ];
  void _readCounts(String key, Map<String, int> target) {
    final raw = _prefs?.getString(key);
    if (raw == null) return;
    try {
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      target.addAll(decoded.map((k, v) => MapEntry(k, (v as num).toInt())));
    } catch (_) {/* Keep save data usable if a value is corrupted. */}
  }

  Future<void> load() async {
    _prefs = await SharedPreferences.getInstance();
    best = _prefs!.getInt('pb_best') ?? 0;
    runs = _prefs!.getInt('pb_runs') ?? 0;
    selectedSkin = _prefs!.getInt('pb_skin') ?? 0;
    sound = _prefs!.getBool('pb_sound') ?? true;
    music = _prefs!.getBool('pb_music') ?? true;
    soundVolume = (_prefs!.getDouble('pb_sound_volume') ?? .75).clamp(0.0, 1.0);
    musicVolume = (_prefs!.getDouble('pb_music_volume') ?? .45).clamp(0.0, 1.0);
    discovered.addAll(_prefs!.getStringList('pb_discovered') ?? []);
    highs.addAll((_prefs!.getStringList('pb_highs') ?? [])
        .map((s) => int.tryParse(s) ?? 0));
    _readCounts('pb_encounters', encounters);
    _readCounts('pb_defeats', defeats);
    _readCounts('pb_power_uses', powerUses);
    achievements.addAll(_prefs!.getStringList('pb_achievements') ?? []);
    totalKills = _prefs!.getInt('pb_total_kills') ?? 0;
    totalBosses = _prefs!.getInt('pb_total_bosses') ?? 0;
    totalTransformations = _prefs!.getInt('pb_total_transformations') ?? 0;
    notifyListeners();
  }

  Future<void> record(RunRules rules) async {
    final altitude = rules.altitude.floor();
    if (altitude > best) best = altitude;
    runs++;
    highs.add(altitude);
    highs.sort((a, b) => b.compareTo(a));
    if (highs.length > 10) highs.removeRange(10, highs.length);
    discovered.addAll(rules.discoveries);
    totalKills += rules.kills;
    totalBosses += rules.bosses;
    totalTransformations += rules.transformations;
    for (final entry in rules.encounterCounts.entries) {
      encounters.update(entry.key, (n) => n + entry.value,
          ifAbsent: () => entry.value);
    }
    for (final entry in rules.defeatCounts.entries) {
      defeats.update(entry.key, (n) => n + entry.value,
          ifAbsent: () => entry.value);
    }
    for (final entry in rules.transformationCounts.entries) {
      powerUses.update(entry.key, (n) => n + entry.value,
          ifAbsent: () => entry.value);
    }
    achievements.add('first_flight');
    if (totalTransformations > 0) achievements.add('triple_fold');
    if (best >= 100000) achievements.add('beyond_earth');
    if (best >= 1000000) achievements.add('deep_space');
    if (best >= 100000000) achievements.add('endless_voyager');
    if (discovered.length == species.length) achievements.add('paper_master');
    if (species
        .where((e) => e.boss && e.region == Region.space)
        .every((e) => (defeats[e.id] ?? 0) > 0))
      achievements.add('cosmic_champion');
    if (species.every((e) => (powerUses[e.id] ?? 0) > 0))
      achievements.add('transformation_master');
    await _prefs!.setInt('pb_best', best);
    await _prefs!.setInt('pb_runs', runs);
    await _prefs!.setStringList('pb_highs', highs.map((e) => '$e').toList());
    await _prefs!.setStringList('pb_discovered', discovered.toList());
    await _prefs!.setString('pb_encounters', jsonEncode(encounters));
    await _prefs!.setString('pb_defeats', jsonEncode(defeats));
    await _prefs!.setString('pb_power_uses', jsonEncode(powerUses));
    await _prefs!.setStringList('pb_achievements', achievements.toList());
    await _prefs!.setInt('pb_total_kills', totalKills);
    await _prefs!.setInt('pb_total_bosses', totalBosses);
    await _prefs!.setInt('pb_total_transformations', totalTransformations);
    notifyListeners();
  }

  bool skinUnlocked(int index) =>
      index == 0 ||
      index < skinMilestones.length && best >= skinMilestones[index];
  Future<void> skin(int index) async {
    if (!skinUnlocked(index)) return;
    selectedSkin = index;
    await _prefs!.setInt('pb_skin', index);
    notifyListeners();
  }

  Future<void> setSound(bool value) async {
    sound = value;
    await _prefs!.setBool('pb_sound', value);
    notifyListeners();
  }

  Future<void> setMusic(bool value) async {
    music = value;
    await _prefs!.setBool('pb_music', value);
    notifyListeners();
  }

  Future<void> setSoundVolume(double value) async {
    soundVolume = value.clamp(0.0, 1.0);
    notifyListeners();
    await _prefs?.setDouble('pb_sound_volume', soundVolume);
  }

  Future<void> setMusicVolume(double value) async {
    musicVolume = value.clamp(0.0, 1.0);
    notifyListeners();
    await _prefs?.setDouble('pb_music_volume', musicVolume);
  }
}
