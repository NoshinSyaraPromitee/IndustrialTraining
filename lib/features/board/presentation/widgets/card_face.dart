import 'package:flutter/material.dart';
import 'package:taskboard/core/theme/trello.dart';
import 'package:taskboard/core/ui/animated_check.dart';
import 'package:taskboard/core/utils/dates.dart';
import 'package:taskboard/features/board/domain/entities/entities.dart';

class CardFace extends StatelessWidget {
  const CardFace({
    super.key,
    required this.card,
    this.lifted = false,
    this.onToggle,
  });
  final TaskCard card;
  final bool lifted;
  final VoidCallback? onToggle;

  static const _small = TextStyle(fontSize: 12, color: Trello.subtle);

  Widget _badges() => Padding(
    padding: const EdgeInsets.only(left: 30, top: 6),
    child: Row(
      children: [
        if (card.due != null) ...[
          const Icon(Icons.schedule, size: 14, color: Trello.subtle),
          const SizedBox(width: 4),
          Text(shortDate(card.due!), style: _small),
          const SizedBox(width: 10),
        ],
        if (card.description.isNotEmpty)
          const Icon(Icons.notes, size: 16, color: Trello.subtle),
      ],
    ),
  );

  @override
  Widget build(BuildContext context) => AnimatedContainer(
    duration: const Duration(milliseconds: 250),
    width: double.infinity,
    margin: const EdgeInsets.only(bottom: 8),
    padding: const EdgeInsets.fromLTRB(10, 10, 12, 10),
    decoration: BoxDecoration(
      color: card.color == null ? Trello.card : Color(card.color!),
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: const Color(0x66000000),
          blurRadius: lifted ? 14 : 1,
          offset: Offset(0, lifted ? 8 : 1),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AnimatedCheck(done: card.done, onTap: onToggle),
            const SizedBox(width: 8),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 2),
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 250),
                  style: TextStyle(
                    fontSize: 14,
                    color: card.done ? Trello.subtle : Trello.text,
                  ),
                  child: Text(card.title),
                ),
              ),
            ),
          ],
        ),
        if (card.description.isNotEmpty || card.due != null) _badges(),
      ],
    ),
  );
}
