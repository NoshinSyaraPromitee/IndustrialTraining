import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:taskboard/features/background/domain/backgrounds.dart';

class PatternPainter extends CustomPainter {
  PatternPainter(this.pattern, {this.alpha = 0.10});
  final BgPattern pattern;
  final double alpha;

  @override
  void paint(Canvas canvas, Size s) {
    final c = Color.fromRGBO(255, 255, 255, alpha);
    final line = Paint()
      ..color = c
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;
    final fill = Paint()..color = c;
    switch (pattern) {
      case BgPattern.none:
        return;
      case BgPattern.dots:
        var row = 0;
        for (double y = 14; y < s.height; y += 26, row++) {
          for (double x = row.isEven ? 14 : 27; x < s.width; x += 26) {
            canvas.drawCircle(Offset(x, y), 2, fill);
          }
        }
      case BgPattern.grid:
        for (double x = 0; x < s.width; x += 40) {
          canvas.drawLine(Offset(x, 0), Offset(x, s.height), line);
        }
        for (double y = 0; y < s.height; y += 40) {
          canvas.drawLine(Offset(0, y), Offset(s.width, y), line);
        }
      case BgPattern.stripes:
        for (double x = -s.height; x < s.width; x += 28) {
          canvas.drawLine(Offset(x, s.height), Offset(x + s.height, 0), line);
        }
      case BgPattern.waves:
        for (double y = 20; y < s.height + 20; y += 34) {
          final path = Path()..moveTo(0, y);
          for (double x = 0; x <= s.width; x += 8) {
            path.lineTo(x, y + 9 * math.sin(x / 32 + y / 18));
          }
          canvas.drawPath(path, line);
        }
      case BgPattern.rings:
        for (double y = 45; y < s.height + 45; y += 90) {
          for (double x = 45; x < s.width + 45; x += 90) {
            canvas.drawCircle(Offset(x, y), 12, line);
            canvas.drawCircle(Offset(x, y), 28, line);
          }
        }
      case BgPattern.zigzag:
        _zigzag(canvas, s, line);
      case BgPattern.chevrons:
        _chevrons(canvas, s, line);
      case BgPattern.diamonds:
        _diamonds(canvas, s, line);
      case BgPattern.crosses:
        _crosses(canvas, s, line);
      case BgPattern.hexagons:
        _hexagons(canvas, s, line);
      case BgPattern.triangles:
        _triangles(canvas, s, line);
      case BgPattern.bubbles:
        _bubbles(canvas, s, line);
      case BgPattern.stars:
        _stars(canvas, s, fill);
      case BgPattern.scales:
        _scales(canvas, s, line);
      case BgPattern.checker:
        _checker(canvas, s, fill);
    }
  }

  @override
  bool shouldRepaint(PatternPainter old) =>
      old.pattern != pattern || old.alpha != alpha;
}

void _zigzag(Canvas canvas, Size s, Paint line) {
  for (double y = 20; y < s.height + 20; y += 30) {
    final path = Path()..moveTo(0, y);
    var up = true;
    for (double x = 16; x <= s.width + 16; x += 16) {
      path.lineTo(x, up ? y - 7 : y + 7);
      up = !up;
    }
    canvas.drawPath(path, line);
  }
}

void _chevrons(Canvas canvas, Size s, Paint line) {
  for (double y = 0; y < s.height + 30; y += 26) {
    for (double x = 0; x < s.width + 36; x += 36) {
      final path = Path()
        ..moveTo(x, y)
        ..lineTo(x + 18, y + 12)
        ..lineTo(x + 36, y);
      canvas.drawPath(path, line);
    }
  }
}

void _diamonds(Canvas canvas, Size s, Paint line) {
  var row = 0;
  for (double y = 22; y < s.height + 22; y += 22, row++) {
    for (double x = row.isEven ? 0 : 22; x < s.width + 44; x += 44) {
      final path = Path()
        ..moveTo(x, y - 14)
        ..lineTo(x + 14, y)
        ..lineTo(x, y + 14)
        ..lineTo(x - 14, y)
        ..close();
      canvas.drawPath(path, line);
    }
  }
}

void _crosses(Canvas canvas, Size s, Paint line) {
  var row = 0;
  for (double y = 18; y < s.height + 18; y += 36, row++) {
    for (double x = row.isEven ? 18 : 36; x < s.width + 36; x += 36) {
      canvas.drawLine(Offset(x - 5, y), Offset(x + 5, y), line);
      canvas.drawLine(Offset(x, y - 5), Offset(x, y + 5), line);
    }
  }
}

void _hexagons(Canvas canvas, Size s, Paint line) {
  const r = 24.0;
  final w = math.sqrt(3) * r;
  var row = 0;
  for (double y = 0; y < s.height + r; y += 1.5 * r, row++) {
    for (double x = row.isEven ? 0 : w / 2; x < s.width + w; x += w) {
      final path = Path();
      for (var i = 0; i < 6; i++) {
        final a = math.pi / 180 * (60 * i - 30);
        final px = x + r * math.cos(a);
        final py = y + r * math.sin(a);
        if (i == 0) {
          path.moveTo(px, py);
        } else {
          path.lineTo(px, py);
        }
      }
      path.close();
      canvas.drawPath(path, line);
    }
  }
}

void _triangles(Canvas canvas, Size s, Paint line) {
  var row = 0;
  for (double y = 20; y < s.height + 20; y += 36, row++) {
    for (double x = row.isEven ? 20 : 44; x < s.width + 48; x += 48) {
      final path = Path()
        ..moveTo(x, y - 12)
        ..lineTo(x + 13, y + 10)
        ..lineTo(x - 13, y + 10)
        ..close();
      canvas.drawPath(path, line);
    }
  }
}

void _bubbles(Canvas canvas, Size s, Paint line) {
  final rnd = math.Random(7);
  final n = math.min(140, math.max(12, (s.width * s.height / 9000).round()));
  for (var i = 0; i < n; i++) {
    canvas.drawCircle(
      Offset(rnd.nextDouble() * s.width, rnd.nextDouble() * s.height),
      6 + rnd.nextDouble() * 26,
      line,
    );
  }
}

void _stars(Canvas canvas, Size s, Paint fill) {
  final rnd = math.Random(11);
  final n = math.min(160, math.max(14, (s.width * s.height / 6500).round()));
  for (var i = 0; i < n; i++) {
    final o = Offset(rnd.nextDouble() * s.width, rnd.nextDouble() * s.height);
    final r = 3 + rnd.nextDouble() * 7;
    final path = Path()
      ..moveTo(o.dx, o.dy - r)
      ..quadraticBezierTo(o.dx, o.dy, o.dx + r, o.dy)
      ..quadraticBezierTo(o.dx, o.dy, o.dx, o.dy + r)
      ..quadraticBezierTo(o.dx, o.dy, o.dx - r, o.dy)
      ..quadraticBezierTo(o.dx, o.dy, o.dx, o.dy - r)
      ..close();
    canvas.drawPath(path, fill);
  }
}

void _scales(Canvas canvas, Size s, Paint line) {
  const r = 20.0;
  var row = 0;
  for (double y = 0; y < s.height + r; y += r, row++) {
    for (double x = row.isEven ? 0 : r; x < s.width + r * 2; x += r * 2) {
      canvas.drawArc(
        Rect.fromCircle(center: Offset(x, y), radius: r),
        0,
        math.pi,
        false,
        line,
      );
    }
  }
}

void _checker(Canvas canvas, Size s, Paint fill) {
  const t = 36.0;
  for (var j = 0; j * t < s.height; j++) {
    for (var i = 0; i * t < s.width; i++) {
      if ((i + j).isEven) {
        canvas.drawRect(Rect.fromLTWH(i * t, j * t, t, t), fill);
      }
    }
  }
}
