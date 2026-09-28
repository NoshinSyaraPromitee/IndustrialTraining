import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskboard/core/theme/trello.dart';
import 'package:taskboard/core/ui/inline_composer.dart';
import 'package:taskboard/features/board/domain/entities/entities.dart';
import 'package:taskboard/features/board/presentation/providers/board_provider.dart';
import 'package:taskboard/features/board/presentation/widgets/card_tile.dart';
import 'package:taskboard/features/board/presentation/widgets/list_progress.dart';

class ListColumn extends StatefulWidget {
  const ListColumn({super.key, required this.list});
  final TaskList list;

  @override
  State<ListColumn> createState() => _ListColumnState();
}

class _ListColumnState extends State<ListColumn> {
  static const _titleStyle = TextStyle(
    fontWeight: FontWeight.w600,
    fontSize: 15,
    color: Trello.text,
  );

  final _c = TextEditingController();
  bool _editing = false;

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  void _start() {
    _c.text = widget.list.title;
    setState(() => _editing = true);
  }

  void _commit() {
    if (!_editing) return;
    final v = _c.text.trim();
    if (v.isNotEmpty && v != widget.list.title) {
      context.read<BoardProvider>().renameList(widget.list.id, v);
    }
    setState(() => _editing = false);
  }

  Widget _title() => _editing
      ? TextField(
          controller: _c,
          autofocus: true,
          style: _titleStyle,
          decoration: InputDecoration(
            isDense: true,
            filled: true,
            fillColor: Trello.card,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 8,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(6),
              borderSide: BorderSide.none,
            ),
          ),
          onSubmitted: (_) => _commit(),
          onTapOutside: (_) => _commit(),
        )
      : GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: _start,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Text(widget.list.title, style: _titleStyle),
          ),
        );

  Widget _header(BoardProvider board) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 6, 4, 4),
    child: Row(
      children: [
        Expanded(child: _title()),
        Text(
          '${widget.list.cards.length}',
          style: const TextStyle(fontSize: 13, color: Trello.subtle),
        ),
        PopupMenuButton<String>(
          icon: const Icon(Icons.more_horiz, color: Trello.subtle),
          onSelected: (v) {
            if (v == 'rename') {
              _start();
            } else {
              board.deleteList(widget.list.id);
            }
          },
          itemBuilder: (_) => const [
            PopupMenuItem(value: 'rename', child: Text('Rename list')),
            PopupMenuItem(value: 'delete', child: Text('Delete list')),
          ],
        ),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    final list = widget.list;
    final board = context.read<BoardProvider>();
    return DragTarget<String>(
      onAcceptWithDetails: (d) => board.moveCard(d.data, list.id),
      builder: (context, candidate, _) => Container(
        decoration: BoxDecoration(
          color: candidate.isNotEmpty ? Trello.listHover : Trello.list,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _header(board),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
              child: ListProgress(list: list),
            ),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
                children: [
                  for (final c in list.cards)
                    CardTile(key: ValueKey(c.id), card: c, listId: list.id),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
              child: InlineComposer(
                idleLabel: 'Add a card',
                hint: 'Enter card title',
                submitLabel: 'Add card',
                onSubmit: (t) => board.addCard(list.id, t),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
