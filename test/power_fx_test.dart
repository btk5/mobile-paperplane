import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_paperplane/catalog.dart';
import 'package:mobile_paperplane/power_fx.dart';
import 'package:mobile_paperplane/rules.dart';

void main() {
  test('all 37 species have effect definitions', () {
    expect(species.length, 37);
    for (final entry in species) {
      expect(patternFor(entry).shots, greaterThan(0));
      expect(patternFor(entry).sound, isNotEmpty);
    }
  });
  test('requested Thai powers have exact effects and shot counts', () {
    final byId = {for (final s in species) s.id: s};
    expect(patternFor(byId['thai_kite']!).shape, PowerShape.lightning);
    expect(patternFor(byId['thai_kite']!).shots, inInclusiveRange(2, 3));
    expect(patternFor(byId['golden_gecko']!).shape, PowerShape.shockwave);
    expect(patternFor(byId['golden_gecko']!).shots, inInclusiveRange(2, 4));
    expect(patternFor(byId['lantern_spirit']!).shape, PowerShape.laser);
    expect(patternFor(byId['lantern_spirit']!).shots, 1);
    expect(patternFor(byId['hornbill']!).shape, PowerShape.leaf);
    expect(patternFor(byId['hornbill']!).shots, inInclusiveRange(3, 5));
    expect(patternFor(byId['orchid']!).shape, PowerShape.ricochet);
    expect(patternFor(byId['orchid']!).shots, inInclusiveRange(4, 5));
  });
  test('auto cleared enemies do not advance combo', () {
    final rules = RunRules(Region.thailand);
    final kite = species.firstWhere((s) => s.id == 'thai_kite');
    rules.defeat(kite);
    expect(rules.combo, 1);
    rules.defeatWithoutCombo(kite);
    expect(rules.combo, 1);
    expect(rules.kills, 2);
  });
}
