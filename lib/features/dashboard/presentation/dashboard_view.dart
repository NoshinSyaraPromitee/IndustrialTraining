import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskboard/features/board/domain/entities/entities.dart';
import 'package:taskboard/features/board/presentation/providers/board_provider.dart';
import 'package:taskboard/core/theme/trello.dart';
import 'package:taskboard/features/board/presentation/utils/due_status.dart';
import 'package:taskboard/core/ui/panel_shell.dart';
import 'package:taskboard/core/ui/simple_bar_chart.dart';
import 'package:taskboard/core/ui/view_close_button.dart';

class TaskDashboardView extends StatelessWidget {
  const TaskDashboardView({super.key, required this.onClose});
  final VoidCallback onClose;

  Widget _card(String title, Widget chart) => Container(
    padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
    decoration: BoxDecoration(
      color: const Color(0xFF1D2125),
      borderRadius: BorderRadius.circular(12),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Trello.text,
          ),
        ),
        const SizedBox(height: 20),
        chart,
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    final board = context.watch<BoardProvider>();
    final lists = board.lists
        .where((l) => l.id != inboxId || l.cards.isNotEmpty)
        .toList();
    final counts = {for (final s in DueStatus.values) s: 0};
    for (final e in board.allCards) {
      final s = dueStatusOf(e.$1);
      counts[s] = counts[s]! + 1;
    }

    final perList = _card(
      'Cards per list',
      SimpleBarChart(
        labels: [for (final l in lists) board.listLabel(l)],
        values: [for (final l in lists) l.cards.length],
        colors: [for (final _ in lists) const Color(0xFFCFD3D8)],
      ),
    );
    final perDue = _card(
      'Cards per due date',
      SimpleBarChart(
        labels: [for (final s in DueStatus.values) s.label],
        values: [for (final s in DueStatus.values) counts[s]!],
        colors: [for (final s in DueStatus.values) s.color],
      ),
    );

    return PanelShell(
      icon: Icons.speed_outlined,
      title: 'Dashboard',
      trailing: ViewCloseButton(onPressed: onClose),
      child: LayoutBuilder(
        builder: (context, box) => SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 16),
          child: box.maxWidth >= 900
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: perList),
                    const SizedBox(width: 16),
                    Expanded(child: perDue),
                  ],
                )
              : Column(children: [perList, const SizedBox(height: 16), perDue]),
        ),
      ),
    );
  }
}
