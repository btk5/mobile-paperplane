import 'package:flame/game.dart' show GameWidget;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import 'package:provider/provider.dart';
import 'catalog.dart';
import 'rules.dart';
import 'save.dart';
import 'sky_game.dart';
import 'game_audio.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final store = SaveData();
  await store.load();
  runApp(
      ChangeNotifierProvider.value(value: store, child: const PaperboundApp()));
}

class PaperboundApp extends StatelessWidget {
  const PaperboundApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
      title: 'Paperbound: Beyond the Sky',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
              seedColor: const Color(0xff70c8ee), brightness: Brightness.dark),
          scaffoldBackgroundColor: const Color(0xff101a37)),
      home: const MainMenu());
}

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});
  @override
  State<MainMenu> createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  final GameAudio _menuAudio = GameAudio();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final s = context.read<SaveData>();
      _menuAudio.music = s.music;
      _menuAudio.musicVolume = s.musicVolume;
      _menuAudio.playMenu();
    });
  }

  @override
  void dispose() {
    _menuAudio.dispose();
    super.dispose();
  }

  Future<void> _play() async {
    await _menuAudio.stopMusic();
    if (!mounted) return;
    await Navigator.push(
        context, _flightRoute(const PlayScreen(region: Region.thailand)));
    if (!mounted) return;
    final s = context.read<SaveData>();
    _menuAudio.music = s.music;
    _menuAudio.musicVolume = s.musicVolume;
    _menuAudio.playMenu();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
            child: Center(
                child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 430),
          child: Stack(children: [
            const Positioned.fill(child: _PixelSky()),
            ListView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
                children: [
                  const SizedBox(height: 20),
                  const Text('PAPERBOUND',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 32,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 2.5,
                          color: Color(0xffffe5a2))),
                  const Text('BEYOND THE SKY',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'monospace',
                          letterSpacing: 3,
                          color: Color(0xff9cecff))),
                  const SizedBox(height: 14),
                  const SizedBox(height: 176, child: _FlyingPlane()),
                  const SizedBox(height: 14),
                  const Text('ONE TAP  •  TWO LANES  •  ENDLESS SKY',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: 'monospace',
                          fontSize: 10,
                          color: Color(0xffd2e7f6))),
                  const SizedBox(height: 26),
                  FilledButton.icon(
                      onPressed: _play,
                      icon: const Icon(Icons.play_arrow_rounded),
                      label: const Text('START FLIGHT',
                          style: TextStyle(
                              fontFamily: 'monospace',
                              fontWeight: FontWeight.bold))),
                  const SizedBox(height: 10),
                  _nav(context, 'ENEMY ENCYCLOPEDIA', Icons.auto_stories,
                      const Encyclopedia()),
                  _nav(context, 'PAPERPLANE COLLECTION', Icons.style,
                      const SkinsPage()),
                  _nav(context, 'HIGH SCORES', Icons.emoji_events,
                      const HighScores()),
                  _nav(context, 'ACHIEVEMENTS', Icons.stars,
                      const Achievements()),
                  _nav(context, 'SETTINGS', Icons.settings,
                      const SettingsPage()),
                  const SizedBox(height: 18),
                  Consumer<SaveData>(
                      builder: (_, s, __) => Text(
                          'BEST  ${formatAltitude(s.best)}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontFamily: 'monospace',
                              color: Color(0xffa6efff)))),
                ]),
          ]),
        ))),
      );
}

Route<T> _flightRoute<T>(Widget page) => PageRouteBuilder<T>(
      transitionDuration: const Duration(milliseconds: 680),
      pageBuilder: (_, animation, __) => page,
      transitionsBuilder: (_, animation, __, child) {
        final curve =
            CurvedAnimation(parent: animation, curve: Curves.easeInOutCubic);
        return FadeTransition(
            opacity: curve,
            child: SlideTransition(
                position:
                    Tween<Offset>(begin: const Offset(0, .16), end: Offset.zero)
                        .animate(curve),
                child: child));
      },
    );

class _FlyingPlane extends StatefulWidget {
  const _FlyingPlane();
  @override
  State<_FlyingPlane> createState() => _FlyingPlaneState();
}

class _FlyingPlaneState extends State<_FlyingPlane>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 2800))
    ..repeat(reverse: true);
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: controller,
        builder: (_, __) {
          final t = controller.value;
          return Transform.translate(
              offset: Offset(math.sin(t * math.pi * 2) * 28, -t * 32),
              child: Transform.rotate(
                  angle: math.sin(t * math.pi * 2) * .10,
                  child: Center(
                      child: Image.asset('assets/images/plane_4.png',
                          width: 128,
                          height: 128,
                          fit: BoxFit.contain,
                          filterQuality: FilterQuality.none))));
        },
      );
}

class _PixelSky extends StatelessWidget {
  const _PixelSky();
  @override
  Widget build(BuildContext context) => IgnorePointer(
          child: Opacity(
        opacity: .40,
        child: Image.asset('assets/images/bg_thailand.png',
            fit: BoxFit.cover,
            filterQuality: FilterQuality.none,
            errorBuilder: (_, __, ___) =>
                const ColoredBox(color: Color(0xff15294b))),
      ));
}

Widget _nav(BuildContext context, String label, IconData icon, Widget page) =>
    Padding(
        padding: const EdgeInsets.only(top: 8),
        child: OutlinedButton.icon(
            onPressed: () => Navigator.push(
                context, MaterialPageRoute(builder: (_) => page)),
            icon: Icon(icon),
            label: Text(label)));
void _start(BuildContext context, Region? region) {
  const r = Region.thailand;
  Navigator.push(
      context, MaterialPageRoute(builder: (_) => PlayScreen(region: r)));
}

String formatAltitude(num n) =>
    n >= 1000000 ? '${(n / 1000000).toStringAsFixed(2)}M m' : '${n.round()} m';

class PracticeMenu extends StatelessWidget {
  const PracticeMenu({super.key});
  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: const Text('Practice Mode')),
      body: ListView(children: [
        for (final r in Region.values.take(3))
          ListTile(
              title: Text(regionName(r)),
              leading: const Icon(Icons.landscape),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _start(context, r))
      ]));
}

class PlayScreen extends StatefulWidget {
  final Region region;
  const PlayScreen({super.key, required this.region});
  @override
  State<PlayScreen> createState() => _PlayScreenState();
}

class _PlayScreenState extends State<PlayScreen> {
  late RunRules rules;
  late SkyGame game;
  bool saving = false;
  final GameAudio audio = GameAudio();
  @override
  void initState() {
    super.initState();
    final settings = context.read<SaveData>();
    audio.sound = settings.sound;
    audio.music = settings.music;
    audio.soundVolume = settings.soundVolume;
    audio.musicVolume = settings.musicVolume;
    audio.prepare();
    audio.startRun();
    _newGame();
  }

  @override
  void dispose() {
    audio.dispose();
    super.dispose();
  }

  void _newGame() {
    rules = RunRules(Region.thailand);
    game = SkyGame(rules, _refresh, _end,
        skinIndex: context.read<SaveData>().selectedSkin, audio: audio);
  }

  void _refresh() {
    if (!mounted) return;
    final settings = context.read<SaveData>();
    audio.sound = settings.sound;
    audio.soundVolume = settings.soundVolume;
    if (audio.musicVolume != settings.musicVolume)
      audio.updateMusicVolume(settings.musicVolume);
    if (audio.music != settings.music)
      audio.setMusic(settings.music, rules.environment);
    setState(() {});
  }

  Future<void> _end() async {
    if (saving) return;
    saving = true;
    await context.read<SaveData>().record(rules);
    if (mounted) setState(() {});
  }

  void _restart() {
    audio.stopMusic().then((_) => audio.startRun());
    setState(() {
      saving = false;
      _newGame();
    });
  }

  @override
  Widget build(BuildContext context) {
    final best = context.watch<SaveData>().best;
    return Scaffold(
        body: SafeArea(
            child: LayoutBuilder(
                builder: (context, box) => Center(
                    child: AspectRatio(
                        aspectRatio: 480 / 854,
                        child: Stack(children: [
                          Positioned.fill(child: GameWidget(game: game)),
                          Positioned.fill(
                              child: GestureDetector(
                                  behavior: HitTestBehavior.translucent,
                                  onTap: game.tap,
                                  child: const SizedBox.expand())),
                          Positioned(
                              top: 8,
                              left: 8,
                              child: IconButton.filledTonal(
                                  onPressed: () {
                                    game.pause();
                                  },
                                  icon: const Icon(Icons.pause))),
                          Positioned(
                              top: 10,
                              right: 12,
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(regionName(rules.environment),
                                        style: const TextStyle(fontSize: 11)),
                                    Text(
                                        rules.shield
                                            ? 'SHIELD ACTIVE'
                                            : 'NO SHIELD',
                                        style: const TextStyle(fontSize: 10))
                                  ])),
                          Positioned(
                              top: 6,
                              left: 80,
                              right: 80,
                              child: Column(children: [
                                Text(formatAltitude(rules.altitude),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 23,
                                        shadows: [
                                          Shadow(
                                              blurRadius: 6,
                                              color: Colors.black)
                                        ])),
                                Text(
                                    'SCORE ${rules.score}  ·  BEST ${formatAltitude(best)}',
                                    style: const TextStyle(fontSize: 11)),
                                Text(
                                    game.boss != null
                                        ? 'BOSS POWER COMBO ${rules.bossCharge}/3'
                                        : rules.comboId == null
                                            ? 'PAPER SLASH · TAP TO SWITCH'
                                            : '${rules.comboId!.replaceAll('_', ' ').toUpperCase()}  ${rules.combo}/3',
                                    style: const TextStyle(
                                        fontSize: 11, color: Color(0xffe9f6ff)))
                              ])),
                          // Compact image-only three-slot combo HUD. No labels or stars.
                          Positioned(
                              left: 10,
                              bottom: 18,
                              child: IgnorePointer(
                                  child: Container(
                                padding: const EdgeInsets.all(7),
                                decoration: BoxDecoration(
                                    color: const Color(0xdd152541),
                                    borderRadius: BorderRadius.circular(14),
                                    border: Border.all(
                                        color: const Color(0x8889d9f6))),
                                child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      for (int i = 0; i < 3; i++)
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 3),
                                          child: Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                                color: const Color(0x77334866),
                                                borderRadius:
                                                    BorderRadius.circular(8)),
                                            child: rules.lastDefeatedId !=
                                                        null &&
                                                    i < rules.lastDefeatedStreak
                                                ? Image.asset(
                                                    'assets/images/combo/${rules.lastDefeatedId}.png',
                                                    fit: BoxFit.contain,
                                                    filterQuality:
                                                        FilterQuality.none,
                                                    errorBuilder: (_, __,
                                                            ___) =>
                                                        const SizedBox.shrink())
                                                : const SizedBox.shrink(),
                                          ),
                                        ),
                                    ]),
                              ))),
                          if (rules.powerTime > 0)
                            Positioned(
                                top: 95,
                                left: 45,
                                right: 45,
                                child: Column(children: [
                                  Text(rules.power!.power,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xffffe69c))),
                                  LinearProgressIndicator(
                                      value: (rules.powerTime /
                                              (rules.power!.boss
                                                  ? 7
                                                  : rules.power!.elite
                                                      ? 4.5
                                                      : 3.5))
                                          .clamp(0, 1))
                                ])),
                          if (game.boss != null)
                            Positioned(
                                top: 125,
                                left: 35,
                                right: 35,
                                child: Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                        color: const Color(0xe0202449),
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: Column(children: [
                                      Text('BOSS · ${game.boss!.name}',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xffffe2a4))),
                                      const SizedBox(height: 6),
                                      LinearProgressIndicator(
                                          value: rules.bossHp / 3,
                                          minHeight: 12,
                                          color: Colors.pinkAccent,
                                          backgroundColor: Colors.white24),
                                      const SizedBox(height: 5),
                                      Text(
                                          'SLASH 3 MATCHING ENEMIES  ·  ${rules.bossCharge}/3',
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(fontSize: 10)),
                                    ]))),
                          if (game.stageBanner > 0)
                            Positioned(
                                top: 190,
                                left: 35,
                                right: 35,
                                child: IgnorePointer(
                                    child: Text(
                                        'STAGE ${rules.stageIndex + 1}  ·  ${regionName(rules.environment).toUpperCase()}',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w900,
                                            color: Color(0xffffe7a5),
                                            shadows: [
                                              Shadow(
                                                  color: Colors.black,
                                                  blurRadius: 10)
                                            ])))),
                          if (rules.paused || rules.ended)
                            Positioned.fill(
                                child: ColoredBox(
                                    color: Colors.black54,
                                    child: Center(
                                        child: Card(
                                            color: const Color(0xff1c2b4e),
                                            child: Padding(
                                                padding:
                                                    const EdgeInsets.all(22),
                                                child: ConstrainedBox(
                                                    constraints:
                                                        const BoxConstraints(
                                                            maxWidth: 300),
                                                    child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Text(
                                                              rules.ended
                                                                  ? 'FLIGHT COMPLETE'
                                                                  : 'PAUSED',
                                                              style: const TextStyle(
                                                                  fontSize: 25,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold)),
                                                          if (rules.ended) ...[
                                                            const SizedBox(
                                                                height: 10),
                                                            Text(
                                                                formatAltitude(
                                                                    rules
                                                                        .altitude),
                                                                style:
                                                                    const TextStyle(
                                                                        fontSize:
                                                                            24)),
                                                            Text(
                                                                'Enemies ${rules.kills} · Bosses ${rules.bosses}'),
                                                            Text(
                                                                'Transformations ${rules.transformations}'),
                                                            Text(
                                                                'Flight ${rules.elapsed.round()} seconds')
                                                          ],
                                                          const SizedBox(
                                                              height: 18),
                                                          if (!rules.ended)
                                                            FilledButton(
                                                                onPressed:
                                                                    game.resume,
                                                                child: const Text(
                                                                    'RESUME')),
                                                          FilledButton(
                                                              onPressed:
                                                                  _restart,
                                                              child: Text(rules
                                                                      .ended
                                                                  ? 'RETRY'
                                                                  : 'RESTART')),
                                                          OutlinedButton(
                                                              onPressed: () =>
                                                                  Navigator.pop(
                                                                      context),
                                                              child: const Text(
                                                                  'HOME')),
                                                        ]))))))),
                        ]))))));
  }
}

class Encyclopedia extends StatelessWidget {
  const Encyclopedia({super.key});
  @override
  Widget build(BuildContext context) {
    final save = context.watch<SaveData>();
    return Scaffold(
        appBar: AppBar(
            title: Text(
                'Encyclopedia ${save.discovered.length}/${species.length}')),
        body: ListView(children: [
          for (final r in Region.values) ...[
            Padding(
                padding: const EdgeInsets.all(16),
                child: Text(regionName(r),
                    style: Theme.of(context).textTheme.titleLarge)),
            for (final s in species.where((e) => e.region == r))
              ListTile(
                  leading: Icon(
                      s.boss
                          ? Icons.auto_awesome
                          : s.elite
                              ? Icons.flash_on
                              : Icons.brightness_5,
                      color: save.discovered.contains(s.id)
                          ? s.color
                          : Colors.grey),
                  title: Text(save.discovered.contains(s.id)
                      ? s.name
                      : '??? Undiscovered'),
                  subtitle: Text(save.discovered.contains(s.id)
                      ? '${s.boss ? 'Boss' : s.elite ? 'Elite' : 'Normal'} · ${s.power} · Seen ${save.encounters[s.id] ?? 0} · Defeated ${save.defeats[s.id] ?? 0} · Powers ${save.powerUses[s.id] ?? 0}'
                      : 'Defeat this creature to reveal'),
                  trailing: save.discovered.contains(s.id)
                      ? const Icon(Icons.check_circle,
                          color: Colors.greenAccent)
                      : const Icon(Icons.lock))
          ]
        ]));
  }
}

class SkinsPage extends StatelessWidget {
  const SkinsPage({super.key});
  static const names = [
    'Classic White',
    'Notebook',
    'Newspaper',
    'Golden Origami',
    'Thai Paper',
    'Jade Festival',
    'Crystal',
    'Galaxy',
    'Holographic',
    'Rainbow',
    'Cosmic Black',
    'Singularity'
  ];
  @override
  Widget build(BuildContext context) {
    final s = context.watch<SaveData>();
    return Scaffold(
        appBar: AppBar(title: const Text('Paperplane Collection')),
        body: ListView(children: [
          for (int i = 0; i < names.length; i++)
            ListTile(
                leading: const Icon(Icons.send),
                title: Text(names[i]),
                subtitle: Text(s.skinUnlocked(i)
                    ? 'Unlocked'
                    : 'Reach ${SaveData.skinMilestones[i]} m'),
                trailing: s.skinUnlocked(i)
                    ? TextButton(
                        onPressed: () => s.skin(i),
                        child:
                            Text(s.selectedSkin == i ? 'SELECTED' : 'SELECT'))
                    : const Icon(Icons.lock))
        ]));
  }
}

class HighScores extends StatelessWidget {
  const HighScores({super.key});
  @override
  Widget build(BuildContext context) {
    final s = context.watch<SaveData>();
    return Scaffold(
        appBar: AppBar(title: const Text('High Scores')),
        body: ListView(children: [
          ListTile(
              title: Text('Best ${formatAltitude(s.best)}'),
              subtitle: Text('${s.runs} flights completed')),
          for (int i = 0; i < s.highs.length; i++)
            ListTile(
                leading: Text('#${i + 1}'),
                title: Text(formatAltitude(s.highs[i])))
        ]));
  }
}

class Achievements extends StatelessWidget {
  const Achievements({super.key});
  @override
  Widget build(BuildContext context) {
    final s = context.watch<SaveData>();
    final milestones = <String, bool>{
      'First Flight': s.runs > 0,
      'Triple Fold': s.totalTransformations > 0,
      'Sky Explorer': s.best >= 10000,
      'Beyond Earth': s.best >= 100000,
      'Deep Space Explorer': s.best >= 1000000,
      'Cosmic Champion': s.achievements.contains('cosmic_champion'),
      'Paper Master': s.discovered.length == species.length,
      'Transformation Master': s.achievements.contains('transformation_master'),
      'Endless Voyager': s.best >= 100000000
    };
    return Scaffold(
        appBar: AppBar(title: const Text('Achievements')),
        body: ListView(children: [
          for (final entry in milestones.entries)
            ListTile(
                leading: Icon(entry.value ? Icons.emoji_events : Icons.lock,
                    color: entry.value ? Colors.amber : Colors.grey),
                title: Text(entry.key),
                subtitle: Text(entry.value ? 'Completed' : 'Not yet unlocked'))
        ]));
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});
  @override
  Widget build(BuildContext context) {
    final s = context.watch<SaveData>();
    return Scaffold(
        appBar: AppBar(title: const Text('Settings')),
        body: ListView(
            padding: const EdgeInsets.symmetric(vertical: 14),
            children: [
              SwitchListTile(
                  title: const Text('Sound effects'),
                  value: s.sound,
                  onChanged: s.setSound),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Row(children: [
                    const Icon(Icons.volume_up_outlined),
                    const SizedBox(width: 12),
                    Expanded(
                        child: Slider(
                            value: s.soundVolume,
                            min: 0,
                            max: 1,
                            divisions: 20,
                            label: '${(s.soundVolume * 100).round()}%',
                            onChanged: s.setSoundVolume)),
                    SizedBox(
                        width: 44,
                        child: Text('${(s.soundVolume * 100).round()}%'))
                  ])),
              SwitchListTile(
                  title: const Text('Background music'),
                  value: s.music,
                  onChanged: s.setMusic),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  child: Row(children: [
                    const Icon(Icons.music_note_outlined),
                    const SizedBox(width: 12),
                    Expanded(
                        child: Slider(
                            value: s.musicVolume,
                            min: 0,
                            max: 1,
                            divisions: 20,
                            label: '${(s.musicVolume * 100).round()}%',
                            onChanged: s.setMusicVolume)),
                    SizedBox(
                        width: 44,
                        child: Text('${(s.musicVolume * 100).round()}%'))
                  ])),
              const ListTile(
                  title: Text('Controls'),
                  subtitle: Text(
                      'Tap to switch lanes. During a transformation, the plane also weaves automatically and casts magic.')),
            ]));
  }
}
