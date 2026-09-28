import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskboard/features/board/domain/entities/entities.dart';
import 'package:taskboard/features/board/presentation/providers/board_provider.dart';
import 'package:taskboard/core/theme/trello.dart';
import 'package:taskboard/features/board/presentation/widgets/card_tile.dart';
import 'package:taskboard/core/ui/panel_shell.dart';

class InboxPanel extends StatefulWidget {
  const InboxPanel({super.key});

  @override
  State<InboxPanel> createState() => _InboxPanelState();
}

class _InboxPanelState extends State<InboxPanel> {
  final _c = TextEditingController();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  void _add(String t) {
    final v = t.trim();
    if (v.isNotEmpty) context.read<BoardProvider>().addCard(inboxId, v);
    _c.clear();
  }

  @override
  Widget build(BuildContext context) {
    final board = context.watch<BoardProvider>();
    return PanelShell(
      icon: Icons.inbox_outlined,
      title: 'Inbox',
      child: DragTarget<String>(
        onAcceptWithDetails: (d) => board.moveCard(d.data, inboxId),
        builder: (context, _, _) => ListView(
          padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
          children: [
            TextField(
              controller: _c,
              onSubmitted: _add,
              style: const TextStyle(color: Trello.text),
              decoration: InputDecoration(
                hintText: 'Add a card',
                hintStyle: const TextStyle(color: Trello.subtle),
                filled: true,
                fillColor: Trello.card,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
            const SizedBox(height: 12),
            for (final c in board.inbox.cards)
              CardTile(key: ValueKey(c.id), card: c, listId: inboxId),
          ],
        ),
      ),
    );
  }
}
