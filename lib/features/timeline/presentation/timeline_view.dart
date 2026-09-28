import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskboard/features/board/domain/entities/entities.dart';
import 'package:taskboard/features/board/presentation/providers/board_provider.dart';
import 'package:taskboard/core/theme/trello.dart';
import 'package:taskboard/core/utils/dates.dart';
import 'package:taskboard/features/board/presentation/utils/due_status.dart';
import 'package:taskboard/features/board/presentation/widgets/card_sheet.dart';
import 'package:taskboard/core/ui/panel_shell.dart';
import 'package:taskboard/core/ui/view_close_button.dart';

class TaskTimelineView extends StatelessWidget {
  const TaskTimelineView({super.key, required this.onClose});
  final VoidCallback onClose;

  static const _dayW = 110.0;
  static const _rowH = 46.0;
  static const _pillStyle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w600,
    color: Trello.onAccent,
  );

  Widget _header(DateTime start, int n, DateTime today) => Row(
    children: [
      for (var i = 0; i < n; i++)
        Builder(
          builder: (_) {
            final d = DateTime(start.year, start.month, start.day + i);
            final isToday = sameDay(d, today);
            return SizedBox(
              width: _dayW,
              height: 48,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    weekdays[d.weekday - 1],
                    style: const TextStyle(fontSize: 11, color: Trello.subtle),
                  ),
                  Text(
                    shortDate(d),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: isToday ? Trello.accent : Trello.text,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
    ],
  );

  Widget _bg(DateTime start, int n, DateTime today) => Row(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      for (var i = 0; i < n; i++)
        Container(
          width: _dayW,
          decoration: BoxDecoration(
            color:
                sameDay(DateTime(start.year, start.month, start.day + i), today)
                ? const Color(0x22579DFF)
                : null,
            border: const Border(left: BorderSide(color: Color(0x1FFFFFFF))),
          ),
        ),
    ],
  );

  /// Pill grows to fit the title instead of cutting it at a fixed width.
  double _pillWidth(TaskCard c, double room) {
    final tp = TextPainter(
      text: TextSpan(text: c.title, style: _pillStyle),
      maxLines: 1,
      textDirection: TextDirection.ltr,
    )..layout();
    final w = tp.width + 28 + (c.done ? 18 : 0);
    return math.max(90.0, math.min(w, room));
  }

  Widget _row(BuildContext context, TaskCard c, DateTime start, double width) {
    final left = daysBetween(start, dateOnly(c.due!)) * _dayW + 4;
    final pillW = _pillWidth(c, width - left - 4);
    return SizedBox(
      height: _rowH,
      child: Stack(
        children: [
          Positioned(
            left: left,
            top: 7,
            width: pillW,
            height: 32,
            child: GestureDetector(
              onTap: () => showCardSheet(context, c),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                alignment: Alignment.centerLeft,
                decoration: BoxDecoration(
                  color: dueStatusOf(c).color,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  children: [
                    if (c.done) ...[
                      const Icon(Icons.check, size: 14, color: Trello.onAccent),
                      const SizedBox(width: 4),
                    ],
                    Expanded(
                      child: Text(
                        c.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Trello.onAccent,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final board = context.watch<BoardProvider>();
    final today = dateOnly(DateTime.now());
    var start = DateTime(today.year, today.month, today.day - 3);
    var end = DateTime(today.year, today.month, today.day + 24);
    var undated = 0;
    for (final e in board.allCards) {
      final d = e.$1.due;
      if (d == null) {
        undated++;
        continue;
      }
      final x = dateOnly(d);
      if (x.isBefore(start)) start = x;
      if (x.isAfter(end)) end = x;
    }
    final n = daysBetween(start, end) + 1;
    final width = n * _dayW;

    final groups = <Widget>[];
    for (final l in board.lists) {
      final dated = l.cards.where((c) => c.due != null).toList()
        ..sort((a, b) => a.due!.compareTo(b.due!));
      if (dated.isEmpty) continue;
      groups.add(
        Container(
          height: 40,
          padding: const EdgeInsets.only(left: 12, top: 10),
          alignment: Alignment.centerLeft,
          child: Text(
            '${board.listLabel(l)} · ${dated.length}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Trello.text,
              fontSize: 14,
            ),
          ),
        ),
      );
      for (final c in dated) {
        groups.add(_row(context, c, start, width));
      }
    }

    return PanelShell(
      icon: Icons.view_timeline_outlined,
      title: 'Timeline',
      trailing: ViewCloseButton(onPressed: onClose),
      child: LayoutBuilder(
        builder: (context, box) => SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: width,
            height: box.maxHeight,
            child: Column(
              children: [
                _header(start, n, today),
                Expanded(
                  child: Stack(
                    children: [
                      Positioned.fill(child: _bg(start, n, today)),
                      if (groups.isEmpty)
                        const Positioned.fill(
                          child: Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: EdgeInsets.all(16),
                              child: Text(
                                'Give cards a due date to see them here',
                                style: TextStyle(color: Trello.subtle),
                              ),
                            ),
                          ),
                        ),
                      ListView(
                        children: [
                          ...groups,
                          if (undated > 0)
                            Padding(
                              padding: const EdgeInsets.all(12),
                              child: Text(
                                '$undated card${undated == 1 ? '' : 's'} without a due date not shown',
                                style: const TextStyle(
                                  color: Trello.subtle,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
