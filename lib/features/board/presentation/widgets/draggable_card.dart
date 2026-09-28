import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskboard/features/board/domain/entities/entities.dart';
import 'package:taskboard/features/board/presentation/providers/board_provider.dart';
import 'package:taskboard/features/board/presentation/widgets/card_face.dart';
import 'package:taskboard/features/board/presentation/widgets/card_sheet.dart';

/// A card you can tap (edit sheet), tick (checkbox) or long-press to drag.
/// Used by the board, the inbox and the planner.
class DraggableCard extends StatelessWidget {
  const DraggableCard({super.key, required this.card});
  final TaskCard card;

  @override
  Widget build(BuildContext context) {
    final board = context.read<BoardProvider>();
    return LayoutBuilder(
      builder: (context, box) => LongPressDraggable<String>(
        data: card.id,
        feedback: Transform.rotate(
          angle: 0.05,
          child: SizedBox(
            width: box.maxWidth,
            child: Material(
              color: Colors.transparent,
              child: CardFace(card: card, lifted: true),
            ),
          ),
        ),
        childWhenDragging: Opacity(opacity: 0.25, child: CardFace(card: card)),
        child: GestureDetector(
          onTap: () => showCardSheet(context, card),
          child: CardFace(
            card: card,
            onToggle: () => board.toggleCard(card.id),
          ),
        ),
      ),
    );
  }
}
