import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskboard/features/background/presentation/background_provider.dart';
import 'package:taskboard/features/background/domain/backgrounds.dart';
import 'package:taskboard/features/background/presentation/pattern_painter.dart';

/// Gradient + pattern behind the whole board; fades when either changes.
class BoardBackdrop extends StatelessWidget {
  const BoardBackdrop({super.key, required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final bg = context.watch<BackgroundProvider>();
    return Stack(
      children: [
        Positioned.fill(
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            decoration: BoxDecoration(
              gradient: gradientOf(bgPresets[bg.gradient]),
            ),
          ),
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 400),
              child: SizedBox.expand(
                key: ValueKey(bg.pattern),
                child: RepaintBoundary(
                  child: CustomPaint(painter: PatternPainter(bg.pattern)),
                ),
              ),
            ),
          ),
        ),
        Positioned.fill(child: child),
      ],
    );
  }
}
