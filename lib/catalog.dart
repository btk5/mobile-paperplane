import 'package:flutter/material.dart';

enum Region { thailand, china, mythical, space }

class Species {
  final String id, name, power;
  final Region region;
  final bool elite, boss;
  final Color color;
  const Species(this.id, this.name, this.power, this.region, this.color,
      {this.elite = false, this.boss = false});
}

const species = <Species>[
  Species('thai_kite', 'Thai Kite', 'Kite Windrush', Region.thailand,
      Color(0xfff6c453)),
  Species('golden_gecko', 'Golden Gecko', 'Golden Wallglider', Region.thailand,
      Color(0xfff9a33b)),
  Species('lantern_spirit', 'Lantern Spirit', 'Lantern Ascension',
      Region.thailand, Color(0xffff7c70)),
  Species('hornbill', 'Tropical Hornbill', 'Hornbill Skywing', Region.thailand,
      Color(0xff66d2bb)),
  Species('orchid', 'Orchid Sprite', 'Orchid Cyclone', Region.thailand,
      Color(0xffd39cf8)),
  Species(
      'naga', 'Storm Naga', 'Naga Tempest', Region.thailand, Color(0xff31cbb7),
      elite: true),
  Species('thunderbird', 'Golden Thunderbird', 'Thunderwing', Region.thailand,
      Color(0xffffd566),
      elite: true),
  Species('monsoon', 'Monsoon Sky Serpent', 'Monsoon Sovereign',
      Region.thailand, Color(0xff45c9a4),
      boss: true),
  Species('sparrow', 'Bamboo Sparrow', 'Bamboo Breeze', Region.china,
      Color(0xff7bc58b)),
  Species('festival_lantern', 'Festival Lantern', 'Crimson Lantern Rush',
      Region.china, Color(0xffff6c6c)),
  Species('paper_fox', 'Paper Fox', 'Foxfire Dash', Region.china,
      Color(0xffffad65)),
  Species('jade_butterfly', 'Jade Butterfly', 'Jade Wingstream', Region.china,
      Color(0xff70e0d0)),
  Species('cloud_carp', 'Cloud Carp', 'Celestial Carp', Region.china,
      Color(0xffa5d8f6)),
  Species('dragon_whelp', 'Crimson Dragon Whelp', 'Crimson Dragonflight',
      Region.china, Color(0xfff25c64),
      elite: true),
  Species('jade_lion', 'Jade Storm Lion', 'Jade Guardian Rush', Region.china,
      Color(0xff64d2ad),
      elite: true),
  Species('cloud_dragon', 'Celestial Cloud Dragon',
      'Celestial Dragon Ascension', Region.china, Color(0xffffca6e),
      boss: true),
  Species('crystal_bat', 'Crystal Bat', 'Crystal Nightflight', Region.mythical,
      Color(0xffaa8bf5)),
  Species('mushroom', 'Mushroom Sprite', 'Sporeburst', Region.mythical,
      Color(0xfff6a0d2)),
  Species(
      'wisp', 'Fairy Wisp', 'Wisp Phase', Region.mythical, Color(0xff9fe9ff)),
  Species('griffin', 'Griffin Chick', 'Griffin Gale', Region.mythical,
      Color(0xffeacb7a)),
  Species('rune_orb', 'Rune Orb', 'Runic Spiral', Region.mythical,
      Color(0xff8ed1ff)),
  Species('phoenix', 'Phoenix Ember', 'Phoenix Rebirth', Region.mythical,
      Color(0xffff8a54),
      elite: true),
  Species('void_mimic', 'Void Mimic', 'Voidwalker', Region.mythical,
      Color(0xff9e7cf6),
      elite: true),
  Species('kraken', 'Arcane Sky Kraken', 'Arcane Kraken Ascension',
      Region.mythical, Color(0xffb178ff),
      boss: true),
  Species(
      'ufo', 'UFO Scout', 'UFO Hyperdrive', Region.space, Color(0xff76dbf9)),
  Species('jelly', 'Cosmic Jellyfish', 'Jellyfish Nebula', Region.space,
      Color(0xffa1e9f5)),
  Species(
      'meteor', 'Meteor Mite', 'Meteor Rush', Region.space, Color(0xffffac6c)),
  Species(
      'beetle', 'Astro Beetle', 'Astro Armor', Region.space, Color(0xffc398f8)),
  Species('plasma', 'Plasma Sprite', 'Plasma Surge', Region.space,
      Color(0xffff9e6d)),
  Species('orbit_eye', 'Orbit Eye', 'Orbital Drive', Region.space,
      Color(0xff8cb8ff)),
  Species('slime', 'Gravity Slime', 'Gravity Flip', Region.space,
      Color(0xff89e8aa)),
  Species(
      'moth', 'Nebula Moth', 'Nebula Wings', Region.space, Color(0xffce96ef)),
  Species('phantom', 'Quantum Phantom', 'Quantum Phase', Region.space,
      Color(0xffb9a3ff)),
  Species(
      'eel', 'Star Eel', 'Starlight Serpent', Region.space, Color(0xff6abaff)),
  Species('leviathan', 'Cosmic Leviathan', 'Leviathan Starstream', Region.space,
      Color(0xff8cb5f9),
      boss: true),
  Species('overlord', 'Nebula Overlord', 'Nebula Dominion', Region.space,
      Color(0xffd59ef8),
      boss: true),
  Species('singularity', 'The Singularity', 'Singularity Overdrive',
      Region.space, Color(0xffffd4a1),
      boss: true),
];

List<Species> availableSpecies(Region region, double altitude) => species
    .where(
        (s) => s.region == region && !s.boss && (!s.elite || altitude >= 10000))
    .toList();

String regionName(Region region) => switch (region) {
      Region.thailand => 'Thailand',
      Region.china => 'China',
      Region.mythical => 'Mythical Realm',
      Region.space => 'Infinite Space'
    };
