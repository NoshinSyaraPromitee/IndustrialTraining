import 'package:flutter/material.dart';
import 'package:taskboard/features/background/domain/backgrounds.dart';
import 'package:taskboard/core/theme/trello.dart';
import 'package:taskboard/features/background/presentation/pattern_painter.dart';

BoxDecoration _tile(BgPreset p, bool selected) => BoxDecoration(
  gradient: gradientOf(p),
  borderRadius: BorderRadius.circular(10),
  border: Border.all(
    color: selected ? Colors.white : Colors.transparent,
    width: 2.5,
  ),
);

class Swatch extends StatelessWidget {
  const Swatch({
    super.key,
    required this.preset,
    required this.selected,
    required this.onTap,
  });
  final BgPreset preset;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Tooltip(
    message: preset.name,
    child: InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 88,
        height: 54,
        alignment: Alignment.center,
        decoration: _tile(preset, selected),
        child: selected ? const Icon(Icons.check, color: Colors.white) : null,
      ),
    ),
  );
}

class PatternTile extends StatelessWidget {
  const PatternTile({
    super.key,
    required this.pattern,
    required this.preset,
    required this.selected,
    required this.onTap,
  });
  final BgPattern pattern;
  final BgPreset preset;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          width: 88,
          height: 54,
          clipBehavior: Clip.antiAlias,
          decoration: _tile(preset, selected),
          child: CustomPaint(painter: PatternPainter(pattern, alpha: 0.35)),
        ),
      ),
      const SizedBox(height: 4),
      Text(
        pattern.label,
        style: TextStyle(
          fontSize: 12,
          color: selected ? Colors.white : Trello.subtle,
        ),
      ),
    ],
  );
}
