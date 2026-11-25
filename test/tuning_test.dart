import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_paperplane/catalog.dart';
import 'package:mobile_paperplane/rules.dart';

void main() {
  test('latest defeated enemy resets streak on a different species', () {
    final r = RunRules(Region.thailand);
    r.defeat(species[0]);
    r.defeat(species[0]);
    expect(r.lastDefeatedStreak, 2);
    r.defeat(species[1]);
    expect(r.lastDefeatedId, species[1].id);
    expect(r.lastDefeatedStreak, 1);
  });
  test('three kills display 3/3 while combo triggers', () {
    final r = RunRules(Region.thailand);
    for (var i = 0; i < 3; i++) {
      r.defeat(species[0]);
    }
    expect(r.lastDefeatedStreak, 3);
    expect(r.power, isNotNull);
    expect(r.combo, 0);
  });
  test('power doubles altitude gain', () {
    final normal = RunRules(Region.thailand);
    final powered = RunRules(Region.thailand);
    powered.activate(species[0]);
    normal.tick(.1);
    powered.tick(.1);
    expect(powered.altitude, closeTo(normal.altitude * 2, .01));
  });
  test('magical auto defeats do not change last manual kill', () {
    final r = RunRules(Region.thailand);
    r.defeat(species[0]);
    r.defeatWithoutCombo(species[1]);
    expect(r.lastDefeatedId, species[0].id);
    expect(r.lastDefeatedStreak, 1);
  });
}
