import 'package:taskboard/features/board/domain/entities/entities.dart';

class ColorCard {
  /// Sets the card color (ARGB int), or resets it when [color] is null.
  List<TaskList> call(List<TaskList> lists, String cardId, int? color) => lists
      .map(
        (l) => l.copyWith(
          cards: l.cards
              .map(
                (c) => c.id == cardId
                    ? c.copyWith(color: color, clearColor: color == null)
                    : c,
              )
              .toList(),
        ),
      )
      .toList();
}
