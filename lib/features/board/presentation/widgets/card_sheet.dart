import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskboard/core/theme/trello.dart';
import 'package:taskboard/core/ui/animated_check.dart';
import 'package:taskboard/features/board/domain/entities/entities.dart';
import 'package:taskboard/features/board/presentation/card_colors.dart';
import 'package:taskboard/features/board/presentation/providers/board_provider.dart';
import 'package:taskboard/features/board/presentation/widgets/due_row.dart';

InputDecoration _box(String hint) => InputDecoration(
  hintText: hint,
  hintStyle: const TextStyle(color: Trello.subtle),
  filled: true,
  fillColor: Trello.list,
  border: OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: BorderSide.none,
  ),
);

class _ColorDot extends StatelessWidget {
  const _ColorDot({
    required this.name,
    required this.color,
    required this.selected,
    required this.onTap,
  });
  final String name;
  final Color? color; // null = default (no color)
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Tooltip(
    message: name,
    child: GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: color ?? Trello.list,
          shape: BoxShape.circle,
          border: Border.all(
            color: selected ? Colors.white : const Color(0x55FFFFFF),
            width: selected ? 2.5 : 1,
          ),
        ),
        child: selected
            ? const Icon(Icons.check, size: 16, color: Colors.white)
            : (color == null
                  ? const Icon(
                      Icons.format_color_reset_outlined,
                      size: 16,
                      color: Trello.subtle,
                    )
                  : null),
      ),
    ),
  );
}

Future<void> showCardSheet(BuildContext context, TaskCard card) {
  final board = context.read<BoardProvider>();
  final title = TextEditingController(text: card.title);
  final desc = TextEditingController(text: card.description);
  var done = card.done;
  var due = card.due;
  var color = card.color;
  var deleted = false;
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Trello.card,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (ctx) => StatefulBuilder(
      builder: (ctx, setS) => SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          16,
          16,
          16,
          16 + MediaQuery.of(ctx).viewInsets.bottom,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                AnimatedCheck(
                  done: done,
                  size: 24,
                  onTap: () {
                    board.toggleCard(card.id);
                    setS(() => done = !done);
                  },
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Trello.text,
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: 'Card title',
                    ),
                  ),
                ),
              ],
            ),
            DueRow(
              due: due,
              onChanged: (d) {
                board.scheduleCard(card.id, d);
                setS(() => due = d);
              },
            ),
            const SizedBox(height: 8),
            const Text(
              'Card color',
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
                _ColorDot(
                  name: 'Default',
                  color: null,
                  selected: color == null,
                  onTap: () {
                    board.colorCard(card.id, null);
                    setS(() => color = null);
                  },
                ),
                for (final c in cardColors)
                  _ColorDot(
                    name: c.name,
                    color: c.color,
                    selected: color == c.color.toARGB32(),
                    onTap: () {
                      board.colorCard(card.id, c.color.toARGB32());
                      setS(() => color = c.color.toARGB32());
                    },
                  ),
              ],
            ),
            const SizedBox(height: 12),
            TextField(
              controller: desc,
              minLines: 3,
              maxLines: 6,
              style: const TextStyle(color: Trello.text),
              decoration: _box('Add a more detailed description...'),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                TextButton.icon(
                  icon: const Icon(Icons.delete_outline),
                  label: const Text('Delete'),
                  style: TextButton.styleFrom(
                    foregroundColor: const Color(0xFFF87168),
                  ),
                  onPressed: () {
                    deleted = true;
                    board.deleteCard(card.id);
                    Navigator.pop(ctx);
                  },
                ),
                const Spacer(),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: Trello.accent,
                    foregroundColor: Trello.onAccent,
                  ),
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Save'),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  ).whenComplete(() {
    // Save on every way of closing (Save button, swipe down, tap outside).
    final t = title.text.trim();
    if (!deleted && t.isNotEmpty) board.editCard(card.id, t, desc.text.trim());
    title.dispose();
    desc.dispose();
  });
}
