import 'package:flutter/material.dart';

class CardColor {
  final String name;
  final Color color;
  const CardColor(this.name, this.color);
}

/// Palette offered in the card sheet.
const cardColors = <CardColor>[
  CardColor('Green', Color(0xFF216E4E)),
  CardColor('Lime', Color(0xFF4C6B1F)),
  CardColor('Yellow', Color(0xFF7F5F01)),
  CardColor('Orange', Color(0xFFA54800)),
  CardColor('Red', Color(0xFFAE2E24)),
  CardColor('Magenta', Color(0xFF943D73)),
  CardColor('Purple', Color(0xFF6E5DC6)),
  CardColor('Blue', Color(0xFF0055CC)),
  CardColor('Teal', Color(0xFF206A83)),
  CardColor('Gray', Color(0xFF596773)),
];
