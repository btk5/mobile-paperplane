import 'package:flutter_test/flutter_test.dart';
import 'package:mobile_paperplane/catalog.dart';
import 'package:mobile_paperplane/rules.dart';

void main() {
  test('Thailand always starts first and 10k does not skip the boss', () {
    final run = RunRules(Region.thailand);
    expect(run.environment, Region.thailand);
    run.altitude = 10001;
    expect(run.stageBossReady, isTrue);
    expect(run.environment, Region.thailand);
  });
  test('boss takes three separate matching triplets; score persists', () {
    final run = RunRules(Region.thailand);
    run.altitude = 10020;
    run.score = 42;
    run.startBoss();
    for (var i = 0; i < 2; i++) {
      expect(run.bossTargetDefeated('thai_kite'), isFalse);
    }
    expect(run.bossTargetDefeated('thai_kite'), isFalse);
    expect(run.bossHp, 2);
    expect(run.bossTargetDefeated('stage_rock'), isFalse);
    expect(run.bossCharge, 0);
    run.bossTargetDefeated('thai_kite');
    expect(run.bossCharge, 1);
    run.bossTargetDefeated('thai_kite');
    run.bossTargetDefeated('thai_kite');
    expect(run.bossHp, 1);
    for (var i = 0; i < 2; i++) {
      expect(run.bossTargetDefeated('golden_gecko'), isFalse);
    }
    expect(run.bossTargetDefeated('golden_gecko'), isTrue);
    expect(run.bossHp, 0);
    final oldScore = run.score;
    run.clearStage();
    expect(run.environment, Region.china);
    expect(run.score, oldScore);
    expect(run.altitude, 10020);
    expect(run.stageBossReady, isFalse);
  });
}
