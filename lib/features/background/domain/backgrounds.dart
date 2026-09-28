import 'package:flutter/material.dart';

class BgPreset {
  final String name;
  final Color a, b;
  const BgPreset(this.name, this.a, this.b);
}

const bgPresets = [
  BgPreset('Grape', Color(0xFF6C4BA8), Color(0xFFB0508F)),
  BgPreset('Ocean', Color(0xFF0079BF), Color(0xFF5067C5)),
  BgPreset('Forest', Color(0xFF1F7A4D), Color(0xFF7BB661)),
  BgPreset('Sunset', Color(0xFFE2603B), Color(0xFFD9427B)),
  BgPreset('Lagoon', Color(0xFF00A6A6), Color(0xFF1F6FEB)),
  BgPreset('Berry', Color(0xFF8E2E6A), Color(0xFF4B2A8A)),
  BgPreset('Slate', Color(0xFF36454F), Color(0xFF5C6B77)),
  BgPreset('Gold', Color(0xFFE0A526), Color(0xFFE6743C)),
  BgPreset('Rose', Color(0xFFD6537A), Color(0xFFF08A6B)),
  BgPreset('Midnight', Color(0xFF0B1B3A), Color(0xFF3B2A6E)),
  BgPreset('Mint', Color(0xFF2BB39A), Color(0xFF86D67B)),
  BgPreset('Charcoal', Color(0xFF1B1F23), Color(0xFF3A3F45)),
];

/// New patterns are appended so previously saved indexes stay valid.
enum BgPattern {
  none,
  dots,
  grid,
  stripes,
  waves,
  rings,
  zigzag,
  chevrons,
  diamonds,
  crosses,
  hexagons,
  triangles,
  bubbles,
  stars,
  scales,
  checker,
}

extension BgPatternLabel on BgPattern {
  String get label => name[0].toUpperCase() + name.substring(1);
}

LinearGradient gradientOf(BgPreset p) => LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [p.a, p.b],
);
