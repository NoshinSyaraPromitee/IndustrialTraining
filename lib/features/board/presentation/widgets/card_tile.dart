import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskboard/features/board/domain/entities/entities.dart';
import 'package:taskboard/features/board/presentation/providers/board_provider.dart';
import 'package:taskboard/core/theme/trello.dart';
import 'package:taskboard/features/board/presentation/widgets/draggable_card.dart';

/// A card inside a list: dropping another card on it inserts above it.
class CardTile extends StatelessWidget {
  const CardTile({super.key, required this.card, required this.listId});
  final TaskCard card;
  final String listId;

  @override
  Widget build(BuildContext context) {
    final board = context.read<BoardProvider>();
    return DragTarget<String>(
      onWillAcceptWithDetails: (d) => d.data != card.id,
      onAcceptWithDetails: (d) =>
          board.moveCard(d.data, listId, beforeCardId: card.id),
      builder: (context, candidate, _) => Column(
        children: [
          if (candidate.isNotEmpty)
            Container(
              height: 3,
              margin: const EdgeInsets.only(bottom: 6),
              decoration: BoxDecoration(
                color: Trello.dropLine,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          DraggableCard(card: card),
        ],
      ),
    );
  }
}
