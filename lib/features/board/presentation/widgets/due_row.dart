import 'package:flutter/material.dart';
import 'package:taskboard/core/theme/trello.dart';
import 'package:taskboard/core/utils/dates.dart';

class DueRow extends StatelessWidget {
  const DueRow({super.key, required this.due, required this.onChanged});
  final DateTime? due;
  final ValueChanged<DateTime?> onChanged;

  Future<void> _pick(BuildContext context) async {
    final now = DateTime.now();
    final d = await showDatePicker(
      context: context,
      initialDate: due ?? now,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 3),
    );
    if (d != null) onChanged(dateOnly(d));
  }

  @override
  Widget build(BuildContext context) => Row(
    children: [
      const Icon(Icons.event, size: 18, color: Trello.subtle),
      const SizedBox(width: 4),
      TextButton(
        onPressed: () => _pick(context),
        child: Text(due == null ? 'Add due date' : dayLabel(due!)),
      ),
      if (due != null)
        IconButton(
          icon: const Icon(Icons.close, size: 18),
          color: Trello.subtle,
          onPressed: () => onChanged(null),
        ),
    ],
  );
}
