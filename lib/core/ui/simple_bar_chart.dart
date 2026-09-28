import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:taskboard/core/theme/trello.dart';

class SimpleBarChart extends StatelessWidget {
  const SimpleBarChart({
    super.key,
    required this.labels,
    required this.values,
    required this.colors,
    this.height = 300,
  });
  final List<String> labels;
  final List<int> values;
  final List<Color> colors;
  final double height;

  static const _gutter = 36.0;

  @override
  Widget build(BuildContext context) {
    final maxV = values.fold<int>(0, (a, b) => a > b ? a : b);
    final step = maxV <= 4 ? 1 : (maxV / 4).ceil();
    final top = step * 4;
    return SizedBox(
      height: height,
      child: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: LayoutBuilder(
                builder: (context, box) {
                  final h = box.maxHeight;
                  return Stack(
                    clipBehavior: Clip.none,
                    children: [
                      Positioned.fill(
                        left: _gutter,
                        child: CustomPaint(painter: _GridPainter()),
                      ),
                      for (var i = 0; i <= 4; i++)
                        Positioned(
                          left: 0,
                          width: _gutter - 10,
                          top: h * (1 - i / 4) - 9,
                          child: Text(
                            '${i * step}',
                            textAlign: TextAlign.right,
                            style: const TextStyle(
                              color: Trello.subtle,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      Positioned.fill(
                        left: _gutter,
                        child: Row(
                          children: [
                            for (var i = 0; i < values.length; i++)
                              Expanded(
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: TweenAnimationBuilder<double>(
                                    tween: Tween<double>(
                                      begin: 0,
                                      end: values[i] / top,
                                    ),
                                    duration: const Duration(milliseconds: 500),
                                    curve: Curves.easeOutCubic,
                                    builder: (_, f, _) => FractionallySizedBox(
                                      widthFactor: .6,
                                      heightFactor: f.clamp(0.0, 1.0),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: colors[i],
                                          borderRadius:
                                              const BorderRadius.vertical(
                                                top: Radius.circular(3),
                                              ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.only(left: _gutter),
            child: Row(
              children: [
                for (final l in labels)
                  Expanded(
                    child: Text(
                      l,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Trello.subtle,
                        fontSize: 13,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final p = Paint()
      ..color = const Color(0x66FFFFFF)
      ..strokeWidth = 1;
    for (var i = 0; i <= 4; i++) {
      final y = size.height * (1 - i / 4);
      for (double x = 0; x < size.width; x += 8) {
        canvas.drawLine(
          Offset(x, y),
          Offset(math.min(x + 4, size.width), y),
          p,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
