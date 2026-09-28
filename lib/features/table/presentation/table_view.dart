import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskboard/features/board/domain/entities/entities.dart';
import 'package:taskboard/features/board/presentation/providers/board_provider.dart';
import 'package:taskboard/core/theme/trello.dart';
import 'package:taskboard/core/utils/dates.dart';
import 'package:taskboard/features/board/presentation/utils/due_status.dart';
import 'package:taskboard/core/ui/animated_check.dart';
import 'package:taskboard/features/board/presentation/widgets/card_sheet.dart';
import 'package:taskboard/core/ui/panel_shell.dart';
import 'package:taskboard/core/ui/view_close_button.dart';

class TaskTableView extends StatefulWidget {
  const TaskTableView({super.key, required this.onClose});
  final VoidCallback onClose;

  @override
  State<TaskTableView> createState() => _TaskTableViewState();
}

class _TaskTableViewState extends State<TaskTableView> {
  int _col = 0;
  bool _asc = true;
  static const _heads = ['Card', 'List', 'Due date', 'Status'];
  static const _flex = [5, 3, 3, 3];

  void _sort(int i) => setState(() {
    if (_col == i) {
      _asc = !_asc;
    } else {
      _col = i;
      _asc = true;
    }
  });

  int _cmp((TaskCard, String) a, (TaskCard, String) b) {
    final far = DateTime(9999);
    final r = switch (_col) {
      1 => a.$2.compareTo(b.$2),
      2 => (a.$1.due ?? far).compareTo(b.$1.due ?? far),
      3 => dueStatusOf(a.$1).index.compareTo(dueStatusOf(b.$1).index),
      _ => a.$1.title.toLowerCase().compareTo(b.$1.title.toLowerCase()),
    };
    return _asc ? r : -r;
  }

  Widget _head(int i) => Expanded(
    flex: _flex[i],
    child: InkWell(
      onTap: () => _sort(i),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        child: Row(
          children: [
            Text(
              _heads[i],
              style: const TextStyle(
                color: Trello.subtle,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            if (_col == i)
              Icon(
                _asc ? Icons.arrow_upward : Icons.arrow_downward,
                size: 14,
                color: Trello.subtle,
              ),
          ],
        ),
      ),
    ),
  );

  Widget _cell(int flex, Widget child) => Expanded(
    flex: flex,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: child,
    ),
  );

  Widget _row(BuildContext context, TaskCard c, String list) {
    final board = context.read<BoardProvider>();
    final st = dueStatusOf(c);
    const sub = TextStyle(color: Trello.subtle, fontSize: 13);
    return InkWell(
      onTap: () => showCardSheet(context, c),
      child: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Color(0x1FFFFFFF))),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            _cell(
              5,
              Row(
                children: [
                  AnimatedCheck(
                    done: c.done,
                    size: 20,
                    onTap: () => board.toggleCard(c.id),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      c.title,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: c.done ? Trello.subtle : Trello.text,
                        decoration: c.done ? TextDecoration.lineThrough : null,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _cell(3, Text(list, overflow: TextOverflow.ellipsis, style: sub)),
            _cell(3, Text(c.due == null ? '—' : dayLabel(c.due!), style: sub)),
            _cell(
              3,
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: st.color.withValues(alpha: .2),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    st.label,
                    style: TextStyle(
                      color: st.color,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final board = context.watch<BoardProvider>();
    final rows = [...board.allCards]..sort(_cmp);
    return PanelShell(
      icon: Icons.table_chart_outlined,
      title: 'Table',
      trailing: ViewCloseButton(onPressed: widget.onClose),
      child: LayoutBuilder(
        builder: (context, box) {
          final w = box.maxWidth < 640 ? 640.0 : box.maxWidth;
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: w,
              height: box.maxHeight,
              child: Column(
                children: [
                  Row(
                    children: [
                      for (var i = 0; i < _heads.length; i++) _head(i),
                    ],
                  ),
                  Expanded(
                    child: rows.isEmpty
                        ? const Center(
                            child: Text(
                              'No cards yet',
                              style: TextStyle(color: Trello.subtle),
                            ),
                          )
                        : ListView(
                            children: [
                              for (final e in rows) _row(context, e.$1, e.$2),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
