import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_paperplane/catalog.dart';
import 'package:mobile_paperplane/rules.dart';

void main() {
  test('tap switches lanes', () {
    final r = RunRules(Region.thailand);
    r.switchLane();
    expect(r.lane, 1);
    r.switchLane();
    expect(r.lane, 0);
  });
  test('three matching defeats activate a transformation', () {
    final r = RunRules(Region.thailand);
    for (int i = 0; i < 3; i++) {
      r.defeat(species.first);
    }
    expect(r.power?.id, 'thai_kite');
    expect(r.combo, 0);
  });
  test('different species restart combo', () {
    final r = RunRules(Region.thailand);
    r.defeat(species[0]);
    r.defeat(species[1]);
    expect(r.combo, 1);
    expect(r.comboId, species[1].id);
  });
  test('shield absorbs one hit', () {
    final r = RunRules(Region.thailand)..shield = true;
    expect(r.damage(), false);
    expect(r.shield, false);
    r.tick(1.1);
    expect(r.damage(), true);
  });
  test('boss needs three separate crossings', () {
    final r = RunRules(Region.thailand);
    final boss = species.firstWhere((s) => s.boss);
    r.switchLane();
    expect(r.bossHit(boss), false);
    expect(r.bossHit(boss), false);
    expect(r.bossHp, 2);
    r.switchLane();
    r.bossHit(boss);
    expect(r.bossHp, 1);
    r.switchLane();
    expect(r.bossHit(boss), true);
    expect(r.power?.id, boss.id);
  });
  test('stage progression requires boss clears', () {
    final r = RunRules(Region.thailand)..altitude = 100000;
    expect(r.environment, Region.thailand);
    r.clearStage();
    expect(r.environment, Region.china);
    r.clearStage();
    expect(r.environment, Region.mythical);
    r.clearStage();
    expect(r.environment, Region.space);
  });
  test('37 catalog entries have unique ids and powers', () {
    expect(species.length, 37);
    expect(species.map((e) => e.id).toSet().length, 37);
    expect(species.every((e) => e.power.isNotEmpty), true);
  });
  test('paused timer does not advance', () {
    final r = RunRules(Region.mythical)..paused = true;
    r.tick(3);
    expect(r.elapsed, 0);
  });
  test('altitude keeps increasing', () {
    final r = RunRules(Region.thailand);
    for (int i = 0; i < 2000; i++) {
      r.tick(.05);
    }
    expect(r.altitude, greaterThan(25000));
  });
}
