import 'catalog.dart';

/// Data-driven combat effect specification. Every species has a distinct
/// power label and deterministic effect family. Projectiles never build combos.
enum PowerShape {
  lightning,
  shockwave,
  laser,
  leaf,
  ricochet,
  storm,
  spiral,
  comet,
  shield,
  beam
}

class PowerPattern {
  final PowerShape shape;
  final int shots;
  final double interval;
  final String sound;
  const PowerPattern(this.shape, this.shots, this.interval, this.sound);
}

PowerPattern patternFor(Species species) {
  switch (species.id) {
    case 'thai_kite':
      return const PowerPattern(PowerShape.lightning, 3, .38, 'thunder');
    case 'golden_gecko':
      return const PowerPattern(PowerShape.shockwave, 4, .38, 'wave');
    case 'lantern_spirit':
      return const PowerPattern(PowerShape.laser, 1, 0, 'laser');
    case 'hornbill':
      return const PowerPattern(PowerShape.leaf, 5, .25, 'leaf');
    case 'orchid':
      return const PowerPattern(PowerShape.ricochet, 5, .28, 'orchid');
    case 'naga':
      return const PowerPattern(PowerShape.storm, 6, .27, 'thunder');
    case 'thunderbird':
      return const PowerPattern(PowerShape.lightning, 7, .23, 'thunder');
    case 'sparrow':
      return const PowerPattern(PowerShape.leaf, 4, .32, 'leaf');
    case 'festival_lantern':
      return const PowerPattern(PowerShape.shockwave, 5, .27, 'wave');
    case 'paper_fox':
      return const PowerPattern(PowerShape.comet, 5, .23, 'wind');
    case 'jade_butterfly':
      return const PowerPattern(PowerShape.spiral, 5, .25, 'orchid');
    case 'cloud_carp':
      return const PowerPattern(PowerShape.shockwave, 6, .28, 'wave');
    case 'dragon_whelp':
      return const PowerPattern(PowerShape.beam, 6, .28, 'laser');
    case 'jade_lion':
      return const PowerPattern(PowerShape.shield, 7, .25, 'wave');
    case 'crystal_bat':
      return const PowerPattern(PowerShape.ricochet, 5, .28, 'orchid');
    case 'mushroom':
      return const PowerPattern(PowerShape.shockwave, 5, .32, 'wave');
    case 'wisp':
      return const PowerPattern(PowerShape.spiral, 6, .24, 'orchid');
    case 'griffin':
      return const PowerPattern(PowerShape.leaf, 6, .26, 'wind');
    case 'rune_orb':
      return const PowerPattern(PowerShape.spiral, 6, .24, 'orchid');
    case 'phoenix':
      return const PowerPattern(PowerShape.comet, 7, .22, 'thunder');
    case 'void_mimic':
      return const PowerPattern(PowerShape.ricochet, 7, .24, 'orchid');
    case 'ufo':
      return const PowerPattern(PowerShape.beam, 5, .24, 'laser');
    case 'jelly':
      return const PowerPattern(PowerShape.shockwave, 5, .30, 'wave');
    case 'meteor':
      return const PowerPattern(PowerShape.comet, 6, .25, 'wind');
    case 'beetle':
      return const PowerPattern(PowerShape.shield, 5, .28, 'wave');
    case 'plasma':
      return const PowerPattern(PowerShape.lightning, 6, .25, 'thunder');
    case 'orbit_eye':
      return const PowerPattern(PowerShape.spiral, 7, .22, 'orchid');
    case 'slime':
      return const PowerPattern(PowerShape.shockwave, 6, .27, 'wave');
    case 'moth':
      return const PowerPattern(PowerShape.leaf, 6, .24, 'wind');
    case 'phantom':
      return const PowerPattern(PowerShape.ricochet, 7, .22, 'orchid');
    case 'eel':
      return const PowerPattern(PowerShape.lightning, 7, .22, 'thunder');
    default:
      return const PowerPattern(PowerShape.storm, 8, .25, 'thunder');
  }
}
