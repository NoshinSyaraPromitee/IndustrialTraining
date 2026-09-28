import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskboard/features/board/domain/entities/entities.dart';
import 'package:taskboard/features/board/presentation/providers/board_provider.dart';
import 'package:taskboard/core/theme/trello.dart';
import 'package:taskboard/core/utils/dates.dart';
import 'package:taskboard/features/board/presentation/widgets/card_sheet.dart';
import 'package:taskboard/features/calendar/presentation/event_dialog.dart';
import 'package:taskboard/core/ui/panel_shell.dart';
import 'package:taskboard/core/ui/view_close_button.dart';

class TaskCalendarView extends StatefulWidget {
  const TaskCalendarView({super.key, required this.onClose});
  final VoidCallback onClose;

  @override
  State<TaskCalendarView> createState() => _TaskCalendarViewState();
}

class _TaskCalendarViewState extends State<TaskCalendarView> {
  DateTime _month = DateTime(DateTime.now().year, DateTime.now().month);

  void _shift(int m) =>
      setState(() => _month = DateTime(_month.year, _month.month + m));

  void _today() => setState(() {
    final n = DateTime.now();
    _month = DateTime(n.year, n.month);
  });

  @override
  Widget build(BuildContext context) {
    final board = context.watch<BoardProvider>();
    final lead = _month.weekday - 1;
    final total = DateUtils.getDaysInMonth(_month.year, _month.month);
    final rows = ((lead + total) / 7).ceil();
    return PanelShell(
      icon: Icons.calendar_month_outlined,
      title: '${months[_month.month - 1]} ${_month.year}',
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            color: Trello.text,
            onPressed: () => _shift(-1),
          ),
          OutlinedButton(
            style: OutlinedButton.styleFrom(foregroundColor: Trello.text),
            onPressed: _today,
            child: const Text('Today'),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            color: Trello.text,
            onPressed: () => _shift(1),
          ),
          IconButton.filled(
            tooltip: 'Add event',
            icon: const Icon(Icons.add),
            style: IconButton.styleFrom(
              backgroundColor: Trello.accent,
              foregroundColor: Trello.onAccent,
            ),
            onPressed: () => showEventDialog(context, DateTime.now()),
          ),
          ViewCloseButton(onPressed: widget.onClose),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
        child: Column(
          children: [
            Row(
              children: [
                for (final w in weekdays)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Text(
                        w,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Trello.subtle,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            Expanded(
              child: Column(
                children: [
                  for (var r = 0; r < rows; r++)
                    Expanded(
                      child: Row(
                        children: [
                          for (var c = 0; c < 7; c++)
                            Expanded(
                              child: Builder(
                                builder: (_) {
                                  final day = DateTime(
                                    _month.year,
                                    _month.month,
                                    1 - lead + r * 7 + c,
                                  );
                                  return _DayCell(
                                    day: day,
                                    inMonth: day.month == _month.month,
                                    cards: board.cardsOn(day),
                                  );
                                },
                              ),
                            ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({
    required this.day,
    required this.inMonth,
    required this.cards,
  });
  final DateTime day;
  final bool inMonth;
  final List<TaskCard> cards;

  @override
  Widget build(BuildContext context) {
    final board = context.read<BoardProvider>();
    final isToday = sameDay(day, DateTime.now());
    return DragTarget<String>(
      onAcceptWithDetails: (d) => board.scheduleCard(d.data, day),
      builder: (context, cand, _) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => showEventDialog(context, day),
        child: Container(
          margin: const EdgeInsets.all(2),
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: cand.isNotEmpty
                ? Trello.listHover
                : (inMonth ? const Color(0x33000000) : const Color(0x14000000)),
            borderRadius: BorderRadius.circular(8),
            border: isToday
                ? Border.all(color: Trello.accent, width: 1.5)
                : null,
          ),
          child: LayoutBuilder(
            builder: (context, box) {
              final fit = ((box.maxHeight - 26) / 22).floor();
              final room = fit < 0 ? 0 : fit;
              final show = cards.length <= room
                  ? cards.length
                  : (room - 1 < 0 ? 0 : room - 1);
              return SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '${day.day}',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isToday
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: isToday
                                ? Trello.accent
                                : (inMonth ? Trello.text : Trello.subtle),
                          ),
                        ),
                        const Spacer(),
                        const Icon(Icons.add, size: 14, color: Trello.subtle),
                      ],
                    ),
                    const SizedBox(height: 4),
                    for (final c in cards.take(show)) _Chip(card: c),
                    if (cards.length > show)
                      Text(
                        '+${cards.length - show} more',
                        style: const TextStyle(
                          fontSize: 11,
                          color: Trello.subtle,
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.card});
  final TaskCard card;

  Widget _face() => Container(
    height: 18,
    width: double.infinity,
    margin: const EdgeInsets.only(bottom: 4),
    padding: const EdgeInsets.symmetric(horizontal: 6),
    alignment: Alignment.centerLeft,
    decoration: BoxDecoration(
      color: (card.done ? Trello.green : Trello.accent).withValues(alpha: .25),
      borderRadius: BorderRadius.circular(4),
    ),
    child: Text(
      card.title,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: 11,
        color: Trello.text,
        decoration: card.done ? TextDecoration.lineThrough : null,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) => LongPressDraggable<String>(
    data: card.id,
    feedback: Material(
      color: Colors.transparent,
      child: SizedBox(width: 140, child: _face()),
    ),
    child: GestureDetector(
      onTap: () => showCardSheet(context, card),
      child: _face(),
    ),
  );
}
