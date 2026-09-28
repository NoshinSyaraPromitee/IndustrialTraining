import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:taskboard/features/board/presentation/providers/board_provider.dart';
import 'package:taskboard/core/theme/trello.dart';
import 'package:taskboard/core/utils/dates.dart';
import 'package:taskboard/features/board/presentation/widgets/draggable_card.dart';

/// One day in the planner. Drop a card here to schedule it for that day.
class PlannerDay extends StatelessWidget {
  const PlannerDay({super.key, required this.day});
  final DateTime day;

  @override
  Widget build(BuildContext context) {
    final board = context.watch<BoardProvider>();
    final cards = board.cardsOn(day);
    final (label, rest) = dayParts(day);
    return DragTarget<String>(
      onAcceptWithDetails: (d) => board.scheduleCard(d.data, day),
      builder: (context, cand, _) => AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        margin: const EdgeInsets.only(bottom: 6),
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: cand.isNotEmpty ? Trello.listHover : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: label,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Trello.text,
                    ),
                  ),
                  TextSpan(
                    text: '  $rest',
                    style: const TextStyle(color: Trello.subtle),
                  ),
                ],
              ),
              style: const TextStyle(fontSize: 15),
            ),
            const SizedBox(height: 8),
            if (cards.isEmpty)
              Text(
                cand.isNotEmpty ? 'Drop to schedule' : 'Nothing planned',
                style: const TextStyle(color: Trello.subtle),
              )
            else
              for (final c in cards) DraggableCard(card: c),
          ],
        ),
      ),
    );
  }
}
