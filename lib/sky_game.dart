import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'catalog.dart';
import 'rules.dart';
import 'game_audio.dart';
import 'power_fx.dart';

class SkyGame extends FlameGame {
  final RunRules rules;
  final int skinIndex;
  final void Function() onChanged;
  final void Function() onEnd;
  final math.Random random;
  final GameAudio? audio;
  final List<MagicShot> magicShots = [];
  final Map<String, ui.Image> pixelSprites = {};
  final Map<Region, ui.Image> pixelBackgrounds = {};
  final List<ui.Image> pixelPlane = [];
  final Map<String, ui.Image> thaiSheets = {};
  static const thaiFrames = <String, int>{
    'plane_0': 4,
    'thai_kite': 4,
    'golden_gecko': 4,
    'lantern_spirit': 4,
    'hornbill': 4,
    'orchid': 4,
    'naga': 6,
    'thunderbird': 6,
    'monsoon': 8,
    'falling_rock': 4,
    'tree_branch': 2,
    'temple_roof': 2,
    'energy_barrier': 4,
  };

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    // Cache textures once, never decode images during render().
    for (final enemy in species) {
      pixelSprites[enemy.id] = await images.load('${enemy.id}.png');
    }
    for (final region in Region.values) {
      pixelBackgrounds[region] = await images.load('bg_${region.name}.png');
    }
    for (var i = 0; i < 8; i++) {
      pixelPlane.add(await images.load('plane_$i.png'));
    }
    for (final name in thaiFrames.keys) {
      thaiSheets[name] = await images.load('thailand/${name}_sheet.png');
    }
  }

  void drawPixel(Canvas canvas, ui.Image image, double x, double y,
      double width, double height) {
    canvas.drawImageRect(
        image,
        Rect.fromLTWH(0, 0, image.width.toDouble(), image.height.toDouble()),
        Rect.fromCenter(center: Offset(x, y), width: width, height: height),
        Paint()..filterQuality = FilterQuality.none);
  }

  void drawThaiFrame(
      Canvas canvas, String id, double x, double y, double w, double h) {
    final sheet = thaiSheets[id];
    final count = thaiFrames[id];
    if (sheet == null || count == null) return;
    final frame = ((sceneTime * 8).floor() % count);
    final fw = sheet.width / count;
    canvas.drawImageRect(
        sheet,
        Rect.fromLTWH(fw * frame, 0, fw, sheet.height.toDouble()),
        Rect.fromCenter(center: Offset(x, y), width: w, height: h),
        Paint()..filterQuality = FilterQuality.none);
  }

  Species? _lastPower;
  double _shotClock = 0;
  int _shotsFired = 0;
  SkyGame(this.rules, this.onChanged, this.onEnd,
      {this.skinIndex = 0, int? seed, this.audio})
      : random = math.Random(seed);
  final List<SkyObject> objects = [];
  double spawnClock = .25, sceneTime = 0, crossing = 0, hudClock = 0;
  int lastLane = 0;
  bool finished = false;
  Species? boss;
  double bossTimer = 0;
  bool bossIntroduced = false;
  double bossSpawnClock = 0;
  int bossWave = 0;
  double bossFlash = 0;
  double stageBanner = 2.5;
  String get stageLabel => regionName(rules.environment);

  double nextSpaceBoss = 175000;
  double nextShield = 5500;
  double inputBuffer = 0;
  String? plannedCombo;
  int comboRemaining = 0;
  static const playerY = 595.0;
  // Higher initial speed; capped so obstacles remain readable.
  static const double initialScrollSpeed = 425;
  static const double maximumScrollSpeed = 720;
  static const double initialSpawnInterval = .88;
  static const leftX = 82.0;
  static const rightX = 398.0;
  double playerX = leftX;
  final List<ParticleDot> particles = [];
  final List<SmokePuff> smokePuffs = [];
  double _smokeClock = 0;

  @override
  Color backgroundColor() => const Color(0xff0b1532);

  void tap() {
    if (rules.paused || rules.ended) return;
    if (crossing > .08) {
      if (crossing < .12) inputBuffer = .08;
      return;
    }
    lastLane = rules.lane;
    rules.switchLane();
    crossing = .30;
    onChanged();
  }

  void pause() {
    rules.paused = true;
    onChanged();
  }

  void resume() {
    rules.paused = false;
    onChanged();
  }

  void spawn() {
    if (boss != null) return;
    final region = rules.environment;
    final pool = availableSpecies(region, rules.altitude);
    if (pool.isEmpty) return;
    Species enemy;
    if (comboRemaining > 0 &&
        plannedCombo != null &&
        random.nextDouble() < .75) {
      enemy = pool.firstWhere((e) => e.id == plannedCombo,
          orElse: () => pool[random.nextInt(pool.length)]);
      comboRemaining--;
    } else {
      enemy = pool[random.nextInt(pool.length)];
      if (random.nextDouble() < .30) {
        plannedCombo = enemy.id;
        comboRemaining = 2;
      }
    }
    final lane = random.nextInt(2);
    final x = lane == 0 ? leftX : rightX;
    objects.add(SkyObject(x, -55,
        enemy: enemy,
        radius: enemy.elite ? 24 : 20,
        wave: random.nextDouble() * 6.28,
        facing: lane == 0 ? 1 : -1));
    rules.encounter(enemy);
    if (rules.altitude > 5000 && random.nextDouble() < .20) {
      objects.add(SkyObject(lane == 0 ? rightX : leftX, -240,
          radius: 23, obstacle: true));
    }
    if (rules.altitude > nextShield) {
      objects.add(SkyObject(lane == 0 ? rightX : leftX, -160,
          radius: 18, shield: true));
      nextShield += 6500 + random.nextInt(4000);
    }
  }

  void spawnBoss() {
    final region = rules.environment;
    final list = species.where((s) => s.region == region && s.boss).toList();
    if (list.isEmpty) return;
    boss = list[random.nextInt(list.length)];
    rules.startBoss();
    rules.encounter(boss!);
    audio?.effect('boss');
    rules.bossLastCrossing = -1;
    bossTimer = 0;
    objects.clear();
    bossSpawnClock = .65;
    bossWave = 0;
    bossFlash = 0;
    onChanged();
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (rules.paused || rules.ended) return;
    dt = dt.clamp(0, .05);
    sceneTime += dt;
    if (inputBuffer > 0) inputBuffer = (inputBuffer - dt).clamp(0, .08);
    final previousPower = rules.power;
    final previousRegion = rules.environment;
    rules.tick(dt);
    if (stageBanner > 0) stageBanner -= dt;
    if (bossFlash > 0) bossFlash -= dt;

    if (rules.environment != previousRegion) {
      audio?.setRegion(rules.environment);
    }
    if (rules.power != previousPower && rules.power != null) {
      _lastPower = rules.power;
      _shotClock = 0;
      _shotsFired = 0;
      audio?.effect('power');
      audio?.effect('combo');
      burst(playerX, playerY, rules.power!.color);
    }
    _updateMagic(dt);
    final baseSpeed = (initialScrollSpeed + rules.altitude / 1300)
        .clamp(initialScrollSpeed, maximumScrollSpeed)
        .toDouble();
    final speed = baseSpeed * (rules.powerTime > 0 ? 2.0 : 1.0);
    // Emit small, reusable pixel smoke puffs only while switching lanes.
    if (crossing > 0) {
      _smokeClock -= dt;
      if (_smokeClock <= 0) {
        _smokeClock = .035;
        smokePuffs.add(SmokePuff(playerX, playerY + 14,
            random.nextDouble() * 18 - 9, 34 + random.nextDouble() * 28));
        if (smokePuffs.length > 48) smokePuffs.removeAt(0);
      }
      crossing = (crossing - dt).clamp(0, 1);
      final target = rules.lane == 0 ? leftX : rightX;
      final origin = lastLane == 0 ? leftX : rightX;
      final t = (1 - crossing / .30).clamp(0, 1).toDouble();
      playerX = origin + (target - origin) * (t * t * (3 - 2 * t));
    } else {
      _smokeClock = 0;
      final laneX = rules.lane == 0 ? leftX : rightX;
      // Powers auto-weave gently; taps still switch the preferred lane.
      final weave = rules.powerTime > 0 ? math.sin(sceneTime * 5.5) * 35 : 0.0;
      playerX = (laneX + weave).clamp(40.0, 440.0).toDouble();
      if (inputBuffer > 0) {
        inputBuffer = 0;
        tap();
      }
    }
    // Thailand -> China -> Mythical -> Space. Boss victory, not altitude,
    // is the only way to change regions; score and altitude never reset.
    if (rules.stageBossReady && boss == null && !bossIntroduced) {
      bossIntroduced = true;
      spawnBoss();
    }
    if (boss != null) {
      bossTimer += dt;
      bossSpawnClock -= dt;
      if (bossSpawnClock <= 0) {
        _spawnBossWave();
        bossSpawnClock =
            (1.30 - (3 - rules.bossHp) * .13 - rules.stageIndex * .10)
                .clamp(.72, 1.3)
                .toDouble();
      }
    } else {
      spawnClock -= dt;
      if (spawnClock <= 0) {
        spawn();
        spawnClock = (initialSpawnInterval - rules.altitude / 650000)
            .clamp(.65, initialSpawnInterval)
            .toDouble();
      }
    }
    for (final obj in objects.toList()) {
      final oldY = obj.y;
      obj.y += speed * dt;
      if (obj.enemy != null)
        obj.x += math.sin(sceneTime * 2 + obj.wave) *
            dt *
            (obj.enemy!.elite ? 34 : 15);
      if (obj.y > 920) {
        objects.remove(obj);
        continue;
      }
      final intersectsY = oldY <= playerY + 30 && obj.y >= playerY - 30;
      if (!intersectsY) continue;
      final dist = (obj.x - playerX).abs();
      if (dist > obj.radius + 24) continue;
      if (obj.shield) {
        audio?.effect('shield');
        rules.collectShield();
        burst(obj.x, obj.y, const Color(0xff6fefff));
        objects.remove(obj);
        onChanged();
        continue;
      }
      if (boss != null &&
          crossing > 0 &&
          obj.bossTarget &&
          !obj.obstacle &&
          !obj.consumed) {
        obj.consumed = true;
        final targetId = obj.enemy!.id;
        final defeatedBoss = rules.bossTargetDefeated(targetId);
        audio?.effect('slash', cooldownMs: 55);
        audio?.effect('kill');
        burst(obj.x, obj.y, obj.enemy?.color ?? const Color(0xffffd1a3));
        objects.remove(obj);
        if (rules.bossCharge == 0) {
          bossFlash = .75;
          audio?.effect('power');
          burst(240, playerY - 170, boss!.color);
          if (defeatedBoss) _winBoss();
        }
        onChanged();
        continue;
      }
      if (rules.powerTime > 0 && obj.enemy != null) {
        burst(obj.x, obj.y, obj.enemy!.color);
        objects.remove(obj);
        continue;
      }
      if (obj.enemy != null && crossing > 0) {
        final before = rules.transformations;
        rules.defeat(obj.enemy!);
        audio?.effect('slash', cooldownMs: 55);
        audio?.effect('kill');
        if (rules.transformations > before) {
          _lastPower = rules.power;
          _shotClock = 0;
          _shotsFired = 0;
          audio?.effect('combo');
        }
        burst(obj.x, obj.y, obj.enemy!.color);
        objects.remove(obj);
        onChanged();
      } else if (boss != null && obj.bossTarget && !obj.obstacle) {
        // Missing a boss minion does not end the run.
        objects.remove(obj);
      } else if (rules.damage()) {
        audio?.stopMusic();
        audio?.effect('paper_tear', cooldownMs: 0);
        finished = true;
        onEnd();
        break;
      } else if (rules.invulnerable || rules.shield == false) {
        burst(obj.x, obj.y, Colors.white);
        objects.remove(obj);
        onChanged();
      }
    }
    for (final puff in smokePuffs.toList()) {
      puff.life -= dt;
      puff.x += puff.vx * dt;
      puff.y += puff.vy * dt;
      if (puff.life <= 0) smokePuffs.remove(puff);
    }
    for (final p in particles.toList()) {
      p.life -= dt;
      p.x += p.vx * dt;
      p.y += p.vy * dt;
      if (p.life <= 0) particles.remove(p);
    }
    hudClock += dt;
    if (hudClock > .15) {
      hudClock = 0;
      onChanged();
    }
  }

  void _spawnBossWave() {
    if (boss == null) return;
    final region = rules.environment;
    final pool = availableSpecies(region, rules.altitude)
        .where((e) => !e.elite)
        .toList();
    if (pool.isEmpty) return;
    // Three matching enemies, followed by one dodge-only rock.
    // A single occupied lane keeps every wave avoidable.
    final group = bossWave ~/ 4;
    final useRock = bossWave % 4 == 3;
    final chosen = pool[group % pool.length];
    final lane = bossWave.isEven ? 0 : 1;
    final x = lane == 0 ? leftX : rightX;
    objects.add(SkyObject(x, -65,
        enemy: useRock ? null : chosen,
        obstacle: useRock,
        bossTarget: !useRock,
        radius: useRock ? 22 : 20,
        wave: random.nextDouble() * 6.28,
        facing: lane == 0 ? 1 : -1));
    if (!useRock) rules.encounter(chosen);
    bossWave++;
  }

  void _winBoss() {
    final oldRegion = rules.environment;
    rules.bosses++;
    if (boss != null) {
      rules.discoveries.add(boss!.id);
      rules.defeatCounts.update(boss!.id, (n) => n + 1, ifAbsent: () => 1);
    }
    boss = null;
    bossTimer = 0;
    objects.clear();
    magicShots.clear();
    bossIntroduced = false;
    rules.clearStage();
    stageBanner = 3.0;
    audio?.effect('combo');
    if (rules.environment != oldRegion) audio?.setRegion(rules.environment);
    onChanged();
  }

  void _updateMagic(double dt) {
    final power = rules.power;
    if (power == null) {
      _lastPower = null;
    } else {
      if (_lastPower?.id != power.id) {
        _lastPower = power;
        _shotClock = 0;
        _shotsFired = 0;
      }
      final pattern = patternFor(power);
      _shotClock -= dt;
      if (_shotsFired < pattern.shots && _shotClock <= 0) {
        _shotsFired++;
        _shotClock = pattern.interval;
        audio?.effect(pattern.sound, cooldownMs: 120);
        final target = _findTarget();
        magicShots.add(MagicShot(
            playerX,
            playerY - 35,
            target?.x ?? (65 + random.nextInt(350)).toDouble(),
            target?.y ?? 90 + random.nextDouble() * 280,
            pattern.shape,
            power.color));
      }
    }
    for (final shot in magicShots.toList()) {
      shot.life -= dt;
      if (!shot.hit && shot.life <= .22) {
        shot.hit = true;
        final candidates = objects
            .where((o) =>
                o.enemy != null &&
                (o.x - shot.tx).abs() <
                    (shot.shape == PowerShape.shockwave ? 125 : 72) &&
                (o.y - shot.ty).abs() <
                    (shot.shape == PowerShape.shockwave ? 125 : 85))
            .toList();
        // Magical auto-clears award score, but never advance a 3-of-a-kind combo.
        for (final obj in candidates) {
          rules.defeatWithoutCombo(obj.enemy!);
          burst(obj.x, obj.y, obj.enemy!.color);
          objects.remove(obj);
          audio?.effect('slash', cooldownMs: 90);
          audio?.effect('kill', cooldownMs: 90);
        }
        if (candidates.isNotEmpty) onChanged();
      }
      if (shot.life <= 0) magicShots.remove(shot);
    }
  }

  SkyObject? _findTarget() {
    SkyObject? result;
    double best = double.infinity;
    for (final obj in objects) {
      if (obj.enemy == null || obj.y >= playerY - 40 || obj.y < 0) continue;
      final d = (obj.y - (playerY - 200)).abs() + (obj.x - playerX).abs() * .3;
      if (d < best) {
        best = d;
        result = obj;
      }
    }
    return result;
  }

  void burst(double x, double y, Color color) {
    for (int i = 0; i < 8; i++) {
      final a = i * math.pi / 4;
      particles
          .add(ParticleDot(x, y, math.cos(a) * 120, math.sin(a) * 120, color));
    }
    if (particles.length > 100)
      particles.removeRange(0, particles.length - 100);
  }

  // Original side-profile creature artwork drawn directly on the game canvas.
  // The face looks toward the central flight corridor from either lane.
  void _paintSideFacingEnemy(Canvas canvas, SkyObject obj, Paint paint) {
    final enemy = obj.enemy!;
    canvas.save();
    canvas.translate(obj.x, obj.y);
    canvas.scale(obj.facing.toDouble(), 1);
    final body = enemy.color;
    paint.style = PaintingStyle.fill;
    paint.color = body.withValues(alpha: .20);
    canvas.drawCircle(Offset.zero, obj.radius + 8, paint);
    // Animated fluttering wing, swept backward to reinforce forward-facing profile.
    final flutter = math.sin(sceneTime * 10 + obj.wave) * 5;
    final wing = Path()
      ..moveTo(-5, -4)
      ..quadraticBezierTo(-31, -24 + flutter, -24, 8 + flutter)
      ..quadraticBezierTo(-15, 12, -2, 9)
      ..close();
    paint.color = Color.lerp(body, Colors.white, .32)!;
    canvas.drawPath(wing, paint);
    // Rounded body and tapered tail.
    paint.color = body;
    canvas.drawOval(const Rect.fromLTWH(-15, -13, 31, 27), paint);
    final tail = Path()
      ..moveTo(-12, -3)
      ..lineTo(-30, -11)
      ..lineTo(-24, 4)
      ..lineTo(-30, 14)
      ..lineTo(-9, 8)
      ..close();
    canvas.drawPath(tail, paint);
    // Nose / beak faces into the playfield.
    paint.color = Color.lerp(body, const Color(0xffffe4a4), .55)!;
    final nose = Path()
      ..moveTo(12, -7)
      ..quadraticBezierTo(30, 0, 12, 8)
      ..close();
    canvas.drawPath(nose, paint);
    paint.color = Colors.white;
    canvas.drawCircle(const Offset(7, -5), 5, paint);
    paint.color = const Color(0xff16243b);
    canvas.drawCircle(const Offset(9, -5), 2.3, paint);
    paint.color = Colors.white.withValues(alpha: .85);
    canvas.drawCircle(const Offset(10, -6), .9, paint);
    if (enemy.elite) {
      paint.color = const Color(0xffffedb0);
      final crest = Path()
        ..moveTo(-8, -10)
        ..lineTo(-2, -24)
        ..lineTo(4, -12)
        ..lineTo(11, -21)
        ..lineTo(11, -9)
        ..close();
      canvas.drawPath(crest, paint);
    }
    canvas.restore();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    final sx = size.x / 480, sy = size.y / 854;
    canvas.save();
    canvas.scale(sx, sy);
    final space = rules.environment == Region.space;
    final base = switch (rules.environment) {
      Region.thailand => const Color(0xff7ac8e9),
      Region.china => const Color(0xff8dbad4),
      Region.mythical => const Color(0xff8574cb),
      Region.space => const Color(0xff10152f),
    };
    canvas.drawRect(const Rect.fromLTWH(0, 0, 480, 854), Paint()..color = base);
    final backdrop = pixelBackgrounds[rules.environment];
    if (backdrop != null) {
      canvas.drawImageRect(
          backdrop,
          Rect.fromLTWH(
              0, 0, backdrop.width.toDouble(), backdrop.height.toDouble()),
          const Rect.fromLTWH(0, 0, 480, 854),
          Paint()..filterQuality = FilterQuality.none);
    }
    final paint = Paint();
    for (int i = 0; i < 42; i++) {
      final x = ((i * 131 + 37) % 480).toDouble();
      final y = ((i * 173 + sceneTime * (space ? 55 : 25)) % 950) - 50;
      paint.color = space
          ? Colors.white.withValues(alpha: .25 + (i % 3) * .2)
          : Colors.white.withValues(alpha: .11 + (i % 3) * .08);
      canvas.drawCircle(
          Offset(x, y), space ? 1.5 + (i % 3) : 13 + (i % 4) * 7, paint);
    }
    for (int side = 0; side < 2; side++) {
      final x = side == 0 ? 0.0 : 442.0;
      paint.color = space ? const Color(0xff34355b) : const Color(0xff355a76);
      canvas.drawRect(Rect.fromLTWH(x, 0, 38, 854), paint);
      paint.color = space ? const Color(0xff7a6ee0) : const Color(0xffedcb82);
      for (int j = 0; j < 17; j++) {
        final y = (j * 62 + sceneTime * 100) % 950 - 60;
        canvas.drawRect(Rect.fromLTWH(x + 14, y, 10, 24), paint);
      }
    }
    paint.color = Colors.white.withValues(alpha: .16);
    canvas.drawLine(
        const Offset(240, 0), const Offset(240, 854), paint..strokeWidth = 1);
    for (final obj in objects) {
      if (obj.enemy != null) {
        final sprite = pixelSprites[obj.enemy!.id];
        if (rules.environment == Region.thailand &&
            thaiSheets.containsKey(obj.enemy!.id)) {
          final extent = obj.enemy!.elite ? 78.0 : 60.0;
          drawThaiFrame(canvas, obj.enemy!.id, obj.x, obj.y, extent, extent);
        } else if (sprite != null) {
          final extent = obj.enemy!.elite ? 70.0 : 58.0;
          drawPixel(canvas, sprite, obj.x, obj.y, extent, extent);
        }
      } else if (obj.shield) {
        paint.color = const Color(0xff91f4f5);
        canvas.drawCircle(
            Offset(obj.x, obj.y),
            obj.radius,
            paint
              ..style = PaintingStyle.stroke
              ..strokeWidth = 5);
        paint.style = PaintingStyle.fill;
      } else {
        if (rules.environment == Region.thailand &&
            thaiSheets.containsKey('falling_rock')) {
          drawThaiFrame(canvas, 'falling_rock', obj.x, obj.y, 52, 52);
        } else {
          // Faceted pixel rock instead of the former red placeholder square.
          final rock = Path()
            ..moveTo(obj.x - 22, obj.y - 8)
            ..lineTo(obj.x - 11, obj.y - 22)
            ..lineTo(obj.x + 12, obj.y - 19)
            ..lineTo(obj.x + 23, obj.y - 2)
            ..lineTo(obj.x + 13, obj.y + 20)
            ..lineTo(obj.x - 12, obj.y + 17)
            ..close();
          canvas.drawPath(rock, Paint()..color = const Color(0xff80758f));
          canvas.drawPath(
              Path()
                ..moveTo(obj.x - 22, obj.y - 8)
                ..lineTo(obj.x - 11, obj.y - 22)
                ..lineTo(obj.x + 12, obj.y - 19)
                ..lineTo(obj.x + 1, obj.y - 4)
                ..close(),
              Paint()..color = const Color(0xffb4a5b9));
          canvas.drawLine(
              Offset(obj.x + 1, obj.y - 4),
              Offset(obj.x + 13, obj.y + 20),
              Paint()
                ..color = const Color(0xff514b6c)
                ..strokeWidth = 3);
        }
      }
    }
    if (boss != null) {
      final bx =
          240 + math.sin(sceneTime * (1.7 + (3 - rules.bossHp) * .35)) * 115;
      final bossSprite = pixelSprites[boss!.id];
      if (rules.environment == Region.thailand &&
          thaiSheets.containsKey(boss!.id)) {
        drawThaiFrame(canvas, boss!.id, bx, playerY - 155, 180, 135);
      } else if (bossSprite != null) {
        drawPixel(canvas, bossSprite, bx, playerY - 155, 180, 135);
      }
    }
    if (bossFlash > 0) {
      final flashPaint = Paint()
        ..color =
            const Color(0xffffeb99).withValues(alpha: bossFlash.clamp(0.0, .5));
      canvas.drawCircle(
          const Offset(240, 425), 110 + (1 - bossFlash) * 65, flashPaint);
    }
    if (rules.shield || rules.invulnerable) {
      paint.color = const Color(0xff9ef9ff).withValues(alpha: .25);
      canvas.drawCircle(Offset(playerX, playerY), 38, paint);
    }
    // Draw behind the plane so the smoke never hides its silhouette.
    for (final puff in smokePuffs) {
      final fade = (puff.life / .46).clamp(0.0, 1.0);
      final side = 4.0 + (1 - fade) * 10.0;
      canvas.drawRect(
          Rect.fromCenter(
              center: Offset(puff.x, puff.y), width: side, height: side),
          Paint()
            ..color = const Color(0xffe4eaf2).withValues(alpha: fade * .65));
      canvas.drawRect(
          Rect.fromCenter(
              center: Offset(puff.x - 2, puff.y - 2),
              width: side * .5,
              height: side * .5),
          Paint()..color = Colors.white.withValues(alpha: fade * .4));
    }
    canvas.save();
    canvas.translate(playerX, playerY);
    if (crossing > 0) canvas.rotate((1 - crossing / .30) * math.pi * 2);
    if (rules.powerTime > 0) {
      paint.color = rules.power!.color.withValues(alpha: .5);
      canvas.drawCircle(Offset.zero, 33 + math.sin(sceneTime * 15) * 4, paint);
    }
    if (rules.environment == Region.thailand &&
        skinIndex == 0 &&
        thaiSheets.containsKey('plane_0')) {
      drawThaiFrame(canvas, 'plane_0', 0, 0, 64, 48);
    } else if (pixelPlane.isNotEmpty) {
      final frame =
          crossing > 0 ? ((1 - crossing / .30) * 7).clamp(0, 7).floor() : 0;
      drawPixel(canvas, pixelPlane[frame], 0, 0, 72, 72);
    }
    canvas.restore();
    if (crossing > 0) {
      paint.color = const Color(0xff8df9ff).withValues(alpha: .55);
      canvas.drawCircle(
          Offset(playerX, playerY),
          43,
          paint
            ..style = PaintingStyle.stroke
            ..strokeWidth = 7);
      paint.style = PaintingStyle.fill;
    }
    for (final shot in magicShots) {
      final progress = (1 - shot.life / .65).clamp(0.0, 1.0);
      final opacity = (shot.life / .65).clamp(0.0, 1.0);
      final glow = Paint()
        ..color = shot.color.withValues(alpha: .30 * opacity)
        ..strokeWidth = 18
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;
      final bright = Paint()
        ..color = Colors.white.withValues(alpha: .9 * opacity)
        ..strokeWidth = 5
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;
      final start = Offset(shot.x, shot.y);
      final end = Offset(shot.x + (shot.tx - shot.x) * progress,
          shot.y + (shot.ty - shot.y) * progress);
      if (shot.shape == PowerShape.shockwave ||
          shot.shape == PowerShape.spiral) {
        final r =
            12 + progress * (shot.shape == PowerShape.shockwave ? 140 : 90);
        canvas.drawCircle(end, r, glow..strokeWidth = 13);
        canvas.drawCircle(end, r, bright..strokeWidth = 3);
      } else if (shot.shape == PowerShape.ricochet) {
        final path = Path()
          ..moveTo(start.dx, start.dy)
          ..quadraticBezierTo(470 - start.dx, shot.ty - 75, end.dx, end.dy);
        canvas.drawPath(path, glow);
        canvas.drawPath(path, bright);
      } else if (shot.shape == PowerShape.lightning ||
          shot.shape == PowerShape.storm) {
        final path = Path()..moveTo(start.dx, start.dy);
        for (int j = 1; j <= 8; j++) {
          final t = j / 8;
          path.lineTo(
              start.dx + (end.dx - start.dx) * t + (j.isEven ? 14 : -14),
              start.dy + (end.dy - start.dy) * t);
        }
        canvas.drawPath(path, glow);
        canvas.drawPath(path, bright);
      } else if (shot.shape == PowerShape.leaf) {
        final p = Path()
          ..moveTo(end.dx, end.dy - 23)
          ..quadraticBezierTo(end.dx + 32, end.dy, end.dx, end.dy + 23)
          ..quadraticBezierTo(end.dx - 22, end.dy, end.dx, end.dy - 23);
        canvas.drawPath(
            p,
            Paint()
              ..color = const Color(0xff91ff9c).withValues(alpha: opacity));
        canvas.drawLine(
            Offset(end.dx, end.dy - 20), Offset(end.dx, end.dy + 20), bright);
      } else {
        canvas.drawLine(start, end,
            glow..strokeWidth = shot.shape == PowerShape.laser ? 34 : 15);
        canvas.drawLine(start, end,
            bright..strokeWidth = shot.shape == PowerShape.laser ? 11 : 5);
      }
    }
    for (final p in particles) {
      paint.color = p.color.withValues(alpha: p.life.clamp(0, 1));
      canvas.drawCircle(Offset(p.x, p.y), 3.5, paint);
    }
    canvas.restore();
  }
}

class SkyObject {
  double x, y;
  final Species? enemy;
  final bool obstacle, shield, bossTarget;
  bool consumed = false;
  final double radius, wave;
  final int facing;
  SkyObject(this.x, this.y,
      {this.enemy,
      this.obstacle = false,
      this.shield = false,
      this.bossTarget = false,
      this.radius = 20,
      this.wave = 0,
      this.facing = 1});
}

class ParticleDot {
  double x, y;
  final double vx, vy;
  final Color color;
  double life = .5;
  ParticleDot(this.x, this.y, this.vx, this.vy, this.color);
}

class MagicShot {
  final double x, y, tx, ty;
  final PowerShape shape;
  final Color color;
  double life = .65;
  bool hit = false;
  MagicShot(this.x, this.y, this.tx, this.ty, this.shape, this.color);
}

// Lightweight pixel smoke: no textures, no per-frame image decoding.
class SmokePuff {
  double x, y;
  final double vx, vy;
  double life = .46;
  SmokePuff(this.x, this.y, this.vx, this.vy);
}
