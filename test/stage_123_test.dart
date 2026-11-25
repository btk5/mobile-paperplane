import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_paperplane/catalog.dart';
import 'package:mobile_paperplane/rules.dart';

void main() {
  test('starts in Thailand even when constructed with another region', () {
    final run = RunRules(Region.china);
    expect(run.environment, Region.thailand);
  });
  test('10k triggers boss but does not automatically advance stage', () {
    final run = RunRules(Region.thailand);
    run.altitude = 10000;
    expect(run.stageBossReady, isTrue);
    expect(run.environment, Region.thailand);
  });
  test('boss victories advance Thailand, China, Mythical without losing score',
      () {
    final run = RunRules(Region.thailand);
    run.score = 120;
    run.altitude = 10000;
    run.clearStage();
    expect(run.environment, Region.china);
    expect(run.score, 120);
    run.altitude = 20000;
    expect(run.stageBossReady, isTrue);
    run.clearStage();
    expect(run.environment, Region.mythical);
    expect(run.score, 120);
    run.altitude = 30000;
    run.clearStage();
    expect(run.environment, Region.space);
    expect(run.score, 120);
  });
  test('regional enemy pools stay separate', () {
    for (final region in [Region.thailand, Region.china, Region.mythical]) {
      final pool = availableSpecies(region, 50000);
      expect(pool, isNotEmpty);
      expect(
          pool.every((enemy) => enemy.region == region && !enemy.boss), isTrue);
    }
  });
}
