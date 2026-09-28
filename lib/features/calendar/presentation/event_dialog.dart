import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskboard/core/theme/trello.dart';
import 'package:taskboard/core/utils/dates.dart';
import 'package:taskboard/features/board/domain/entities/entities.dart';
import 'package:taskboard/features/board/presentation/providers/board_provider.dart';

Future<void> showEventDialog(BuildContext context, DateTime day) {
  final board = context.read<BoardProvider>();
  return showDialog<void>(
    context: context,
    builder: (_) => _EventDialog(board: board, day: day),
  );
}

class _EventDialog extends StatefulWidget {
  const _EventDialog({required this.board, required this.day});
  final BoardProvider board;
  final DateTime day;

  @override
  State<_EventDialog> createState() => _EventDialogState();
}

class _EventDialogState extends State<_EventDialog> {
  final _title = TextEditingController();
  late DateTime _date = dateOnly(widget.day);
  late final List<TaskList> _targets = [
    ...widget.board.boardLists,
    widget.board.inbox,
  ];
  late String _listId = _targets.first.id;

  @override
  void dispose() {
    _title.dispose();
    super.dispose();
  }

  void _save() {
    final t = _title.text.trim();
    if (t.isEmpty) return;
    widget.board.addEvent(t, _date, listId: _listId);
    Navigator.pop(context);
  }

  Future<void> _pickDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (d != null) setState(() => _date = dateOnly(d));
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    backgroundColor: Trello.card,
    title: const Text('Add event', style: TextStyle(color: Trello.text)),
    content: SizedBox(
      width: 360,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _title,
            autofocus: true,
            onChanged: (_) => setState(() {}),
            onSubmitted: (_) => _save(),
            style: const TextStyle(color: Trello.text),
            decoration: const InputDecoration(
              hintText: 'Event title',
              hintStyle: TextStyle(color: Trello.subtle),
            ),
          ),
          const SizedBox(height: 16),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(foregroundColor: Trello.text),
            icon: const Icon(Icons.calendar_today_outlined, size: 18),
            label: Text('${dayLabel(_date)}, ${_date.year}'),
            onPressed: _pickDate,
          ),
          const SizedBox(height: 16),
          const Text(
            'Add to list',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Trello.subtle,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final l in _targets)
                ChoiceChip(
                  label: Text(widget.board.listLabel(l)),
                  selected: _listId == l.id,
                  onSelected: (_) => setState(() => _listId = l.id),
                ),
            ],
          ),
        ],
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Cancel'),
      ),
      FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: Trello.accent,
          foregroundColor: Trello.onAccent,
        ),
        onPressed: _title.text.trim().isEmpty ? null : _save,
        child: const Text('Add event'),
      ),
    ],
  );
}
