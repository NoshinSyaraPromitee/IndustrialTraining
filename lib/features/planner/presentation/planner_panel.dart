import 'package:flutter/material.dart';
import 'package:taskboard/core/theme/trello.dart';
import 'package:taskboard/core/utils/dates.dart';
import 'package:taskboard/core/ui/panel_shell.dart';
import 'package:taskboard/features/planner/presentation/planner_day.dart';

class PlannerPanel extends StatefulWidget {
  const PlannerPanel({super.key});

  @override
  State<PlannerPanel> createState() => _PlannerPanelState();
}

class _PlannerPanelState extends State<PlannerPanel> {
  DateTime _start = dateOnly(DateTime.now());

  void _shift(int days) => setState(
    () => _start = DateTime(_start.year, _start.month, _start.day + days),
  );

  @override
  Widget build(BuildContext context) => PanelShell(
    icon: Icons.calendar_today_outlined,
    title: months[_start.month - 1].substring(0, 3),
    trailing: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.chevron_left),
          color: Trello.text,
          onPressed: () => _shift(-7),
        ),
        OutlinedButton(
          style: OutlinedButton.styleFrom(foregroundColor: Trello.text),
          onPressed: () => setState(() => _start = dateOnly(DateTime.now())),
          child: const Text('Today'),
        ),
        IconButton(
          icon: const Icon(Icons.chevron_right),
          color: Trello.text,
          onPressed: () => _shift(7),
        ),
      ],
    ),
    child: ListView.builder(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      itemCount: 14,
      itemBuilder: (_, i) =>
          PlannerDay(day: DateTime(_start.year, _start.month, _start.day + i)),
    ),
  );
}
