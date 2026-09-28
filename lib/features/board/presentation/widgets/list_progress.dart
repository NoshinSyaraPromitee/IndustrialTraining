import 'package:flutter/material.dart';
import 'package:taskboard/features/board/domain/entities/entities.dart';
import 'package:taskboard/core/theme/trello.dart';

/// Animated "how much of this list is done" bar with a percentage label.
class ListProgress extends StatelessWidget {
  const ListProgress({super.key, required this.list});
  final TaskList list;

  @override
  Widget build(BuildContext context) {
    final complete =
        list.cards.isNotEmpty && list.doneCount == list.cards.length;
    final color = complete ? Trello.green : Trello.accent;
    return Row(
      children: [
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(end: list.progress),
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOut,
              builder: (_, v, _) => LinearProgressIndicator(
                value: v,
                minHeight: 6,
                backgroundColor: Trello.card,
                valueColor: AlwaysStoppedAnimation(color),
              ),
            ),
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 40,
          child: Text(
            '${(list.progress * 100).round()}%',
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: complete ? Trello.green : Trello.subtle,
            ),
          ),
        ),
      ],
    );
  }
}
