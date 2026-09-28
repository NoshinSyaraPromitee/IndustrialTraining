import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:taskboard/core/theme/trello.dart';

/// Circle checkbox: the green fill grows from the center, the tick draws
/// itself, and the whole thing gives a small pop. Reverses when unchecked.
class AnimatedCheck extends StatelessWidget {
  const AnimatedCheck({
    super.key,
    required this.done,
    this.onTap,
    this.size = 20,
  });
  final bool done;
  final VoidCallback? onTap;
  final double size;

  @override
  Widget build(BuildContext context) => GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.all(2),
      child: TweenAnimationBuilder<double>(
        tween: Tween<double>(end: done ? 1.0 : 0.0),
        duration: const Duration(milliseconds: 380),
        curve: Curves.easeOut,
        builder: (_, t, _) => Transform.scale(
          scale: 1 + 0.22 * math.sin(t * math.pi),
          child: CustomPaint(
            size: Size.square(size),
            painter: _CheckPainter(t),
          ),
        ),
      ),
    ),
  );
}

class _CheckPainter extends CustomPainter {
  _CheckPainter(this.t);
  final double t;

  @override
  void paint(Canvas canvas, Size s) {
    final center = s.center(Offset.zero);
    final r = s.width / 2 - 1;
    canvas.drawCircle(
      center,
      r,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = Color.lerp(Trello.subtle, Trello.green, t)!,
    );
    canvas.drawCircle(center, r * t, Paint()..color = Trello.green);
    final tick = Path()
      ..moveTo(s.width * 0.28, s.height * 0.52)
      ..lineTo(s.width * 0.44, s.height * 0.68)
      ..lineTo(s.width * 0.73, s.height * 0.34);
    final m = tick.computeMetrics().first;
    final p = ((t - 0.4) / 0.6).clamp(0.0, 1.0);
    canvas.drawPath(
      m.extractPath(0, m.length * p),
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.2
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..color = Colors.white,
    );
  }

  @override
  bool shouldRepaint(_CheckPainter old) => old.t != t;
}
