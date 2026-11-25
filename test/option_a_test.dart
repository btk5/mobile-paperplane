import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_paperplane/catalog.dart';
import 'package:mobile_paperplane/rules.dart';
import 'package:mobile_paperplane/save.dart';

void main() {
  test('all regions have expected species counts', () {
    expect(species.where((s) => s.region == Region.thailand).length, 8);
    expect(species.where((s) => s.region == Region.china).length, 8);
    expect(species.where((s) => s.region == Region.mythical).length, 8);
    expect(species.where((s) => s.region == Region.space).length, 13);
  });
  test('combo survives encounters, shields and lane changes', () {
    final r = RunRules(Region.thailand);
    r.defeat(species.first);
    r.encounter(species[1]);
    r.collectShield();
    r.switchLane();
    expect(r.combo, 1);
    expect(r.comboId, species.first.id);
    expect(r.shieldsCollected, 1);
  });
  test('transformations cannot stack from automatic kills', () {
    final r = RunRules(Region.thailand);
    for (var i = 0; i < 3; i++) {
      r.defeat(species.first);
    }
    r.defeat(species[1]);
    expect(r.power?.id, species.first.id);
    expect(r.combo, 0);
    expect(r.transformations, 1);
  });
  test('shield prevents damage only once', () {
    final r = RunRules(Region.thailand);
    r.collectShield();
    expect(r.damage(), false);
    expect(r.shield, false);
    r.tick(1.1);
    expect(r.damage(), true);
  });
  test('all 12 cosmetic unlock tiers are ordered', () {
    expect(SaveData.skinMilestones.length, 12);
    for (var i = 1; i < SaveData.skinMilestones.length; i++) {
      expect(SaveData.skinMilestones[i],
          greaterThan(SaveData.skinMilestones[i - 1]));
    }
  });
  test('normal enemy pools exclude regional bosses', () {
    for (final region in Region.values) {
      expect(availableSpecies(region, 1000000).every((s) => !s.boss), true);
    }
  });
}
