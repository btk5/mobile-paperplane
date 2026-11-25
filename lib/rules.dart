import 'catalog.dart';

class RunRules {
  int lane = 0;
  int combo = 0;
  String? comboId;
  String? lastDefeatedId;
  int lastDefeatedStreak = 0;
  Species? power;
  double powerTime = 0;
  double recovery = 0;
  double altitude = 0;
  double elapsed = 0;
  int score = 0;
  bool shield = false;
  bool paused = false;
  bool ended = false;
  // A stage is unlocked only by defeating its boss; altitude alone never skips it.
  int stageIndex = 0;
  double stageStartAltitude = 0;
  int bossHp = 3;
  int bossCharge = 0;
  String? bossChargeId;
  int bossHitsFromPowers = 0;
  static const double stageDistance = 10000;
  Region get stageRegion => Region.values[stageIndex < 3 ? stageIndex : 3];
  bool get stageBossReady =>
      stageIndex < 3 && altitude - stageStartAltitude >= stageDistance;
  void startBoss() {
    bossHp = 3;
    bossCharge = 0;
    bossChargeId = null;
  }

  void clearStage() {
    if (stageIndex >= 3) return;
    stageIndex++;
    stageStartAltitude = altitude;
    bossCharge = 0;
    bossChargeId = null;
    recovery = 2.0;
  }

  // Defeating three identical targets during a boss fight launches one power hit.
  // Only defeated enemies count; hazards are dodge-only.
  bool bossTargetDefeated(String targetId) {
    // Obstacles never charge the boss attack.
    if (targetId == 'stage_rock') return false;
    if (bossChargeId == targetId) {
      bossCharge++;
    } else {
      bossChargeId = targetId;
      bossCharge = 1;
    }
    lastDefeatedId = targetId;
    lastDefeatedStreak = bossCharge;
    score += 10;
    if (bossCharge < 3) return false;
    bossCharge = 0;
    bossChargeId = null;
    if (bossHp > 0) bossHp--;
    bossHitsFromPowers++;
    return bossHp == 0;
  }

  int bossLastCrossing = -1;
  int crossingSerial = 0;
  int kills = 0;
  int normalKills = 0;
  int eliteKills = 0;
  int shieldsCollected = 0;
  final Map<String, int> encounterCounts = {};
  final Map<String, int> defeatCounts = {};
  final Map<String, int> transformationCounts = {};
  int bosses = 0;
  int transformations = 0;
  final Set<String> discoveries = {};

  bool get invulnerable => powerTime > 0 || recovery > 0;
  Region get environment => stageRegion;
  final Region startingRegion;
  RunRules(this.startingRegion);

  void switchLane() {
    if (!ended && !paused) {
      lane = 1 - lane;
      crossingSerial++;
    }
  }

  void defeat(Species enemy) {
    if (ended || paused) return;
    discoveries.add(enemy.id);
    if (lastDefeatedId == enemy.id) {
      lastDefeatedStreak = (lastDefeatedStreak + 1).clamp(1, 3);
    } else {
      lastDefeatedId = enemy.id;
      lastDefeatedStreak = 1;
    }
    kills++;
    if (enemy.elite) {
      eliteKills++;
    } else {
      normalKills++;
    }
    defeatCounts.update(enemy.id, (n) => n + 1, ifAbsent: () => 1);
    score += enemy.elite ? 25 : 10;
    if (powerTime > 0) return;
    if (comboId == enemy.id) {
      combo++;
    } else {
      comboId = enemy.id;
      combo = 1;
    }
    if (combo >= 3) {
      activate(enemy);
    }
  }

  void defeatWithoutCombo(Species enemy) {
    if (ended || paused || enemy.boss) return;
    discoveries.add(enemy.id);
    kills++;
    if (enemy.elite) {
      eliteKills++;
    } else {
      normalKills++;
    }
    defeatCounts.update(enemy.id, (n) => n + 1, ifAbsent: () => 1);
    score += enemy.elite ? 25 : 10;
  }

  void activate(Species enemy) {
    power = enemy;
    powerTime = enemy.boss
        ? 7
        : enemy.elite
            ? 4.5
            : 3.5;
    combo = 0;
    comboId = null;
    transformations++;
    transformationCounts.update(enemy.id, (n) => n + 1, ifAbsent: () => 1);
  }

  bool bossHit(Species boss) {
    if (ended || paused || powerTime > 0 || bossLastCrossing == crossingSerial)
      return false;
    bossLastCrossing = crossingSerial;
    bossHp--;
    if (bossHp <= 0) {
      bosses++;
      discoveries.add(boss.id);
      defeatCounts.update(boss.id, (n) => n + 1, ifAbsent: () => 1);
      activate(boss);
      return true;
    }
    return false;
  }

  void encounter(Species enemy) {
    encounterCounts.update(enemy.id, (n) => n + 1, ifAbsent: () => 1);
  }

  void collectShield() {
    shield = true;
    shieldsCollected++;
  }

  bool damage() {
    if (ended || paused || invulnerable) return false;
    if (shield) {
      shield = false;
      recovery = 1.0;
      return false;
    }
    ended = true;
    return true;
  }

  void tick(double dt) {
    if (ended || paused) return;
    elapsed += dt;
    final gain = 280 + (altitude / 100000).clamp(0, 1) * 105;
    altitude += gain * dt * (powerTime > 0 ? 2.0 : 1.0);
    if (powerTime > 0) {
      powerTime -= dt;
      if (powerTime <= 0) {
        powerTime = 0;
        power = null;
        recovery = .6;
      }
    }
    if (recovery > 0) recovery = (recovery - dt).clamp(0, 10);
  }
}
