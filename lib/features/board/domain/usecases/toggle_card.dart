import 'package:taskboard/features/board/domain/entities/entities.dart';

class ToggleCard {
  List<TaskList> call(List<TaskList> lists, String cardId) => lists
      .map(
        (l) => l.copyWith(
          cards: l.cards
              .map((c) => c.id == cardId ? c.copyWith(done: !c.done) : c)
              .toList(),
        ),
      )
      .toList();
}
